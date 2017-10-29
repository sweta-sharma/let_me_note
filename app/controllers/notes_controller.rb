class NotesController < ApplicationController
  def index
    created_notes = current_user.created_notes
    shared_notes = current_user.shared_notes

    render json: {
             created_notes: created_notes.map{ |note| format_note(note) },
             shared_notes: shared_notes.map{ |note| format_note(note) } }
  end

  def show
    note = Note.find_by_id(params[:id])

    authorize note
    render json: { note: format_note(note)}
  end

  def create
    note = current_user.created_notes.build(note_params)
    if note.save
      response = { note: format_note(note), message: 'Note created successfully'}
      render json: response
    else
      render json: note.errors, status: :bad
    end
  end

  def update
    note = Note.find_by_id(params[:id])

    authorize note
    note.title = params[:title] if params[:title].present?
    note.content = params[:content] if params[:content].present?

    if note.save
      response = { note: format_note(note),
                   message: "Note updated successfully"}
      render json: response
    else
      render json: note.errors, status: :bad
    end
  end

  def share
    note = Note.find_by_id(params[:id])
    user = User.find_by_id(params[:share_with_user_id])
    permission = params[:permission]

    authorize note

    shared_note = SharedNote.create(note_id: note.id, user_id: user.id, permission: permission)

    if shared_note.save
      response = {
        note: format_note(note),
        message: "Note shared successfully with user #{user.first_name} with permission #{permission}"
      }
      render json: response
    else
      render json: shared_note.errors, status: :bad
    end
  end

  def unshare
    note = Note.find_by_id(params[:id])
    user = User.find_by_id(params[:unshare_with_user_id])

    authorize note

    shared_note = SharedNote.where(note_id: note.id, user_id: user.id).first

    begin
      shared_note.destroy
      response = {
        note: format_note(note),
        message: "#{user.first_name} can no longer access note."
      }
      render json: response
    rescue Exception => e
      render json: { message: 'Error in deleting' }, status: :bad
    end
  end

  def add_tag
    note = Note.find_by_id(params[:id])
    authorize note, :update?

    tag = Tag.find_or_create_by(name: params[:tag])
    if tag.save
      note.tags << tag unless note.tags.include?(tag)
      render json: {message: 'Tag added successfully'}
    else
      render json: {message: tag.errors}, status: :bad
    end
  end


  def remove_tag
    note = Note.find_by_id(params[:id])
    authorize note, :update?

    tag = Tag.find_by_name(params[:tag])
    if tag.present?
      note.tags -= [tag]
      render json: {message: 'Tag removed successfully'}
    else
      render json: {message: 'no tag found'}, status: :bad
    end
  end

  def destroy
    note = Note.find_by_id(params[:id])
    authorize note

    note.destroy

    response = { message: 'Note deleted successfully'}
    render json: response, status: :deleted
  end

  private

  def note_params
    params.permit(
      :title,
      :content
    )
  end
end
