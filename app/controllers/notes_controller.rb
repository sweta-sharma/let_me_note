class NotesController < ApplicationController
  def index
    created_notes = current_user.created_notes

    render json: { notes: created_notes.map{ |note| format_note(note) } }
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
      render json: response, status: :created
    else
      render json: note.errors, status: :bad
    end
  end

  def update
    note = Note.find_by_id(params[:id])

    authorize note
    note.title = params[:note][:title] if params[:note][:title].present?
    note.content = params[:note][:content] if params[:note][:content].present?

    if note.save
      response = { note: format_note(note), message: 'Note created successfully'}
      render json: response, status: :created
    else
      render json: note.errors, status: :bad
    end
  end

  def share
    note = Note.find_by_id(params[:id])

    authorize note
    SharedNote
  end

  def destroy
    note = Note.find_by_id(params[:id])
    authorize note

    note.destroy
  end

  private

  def format_note(note)
    {
      title: note.title,
      content: note.content,
      updated_at: note.updated_at
    }
  end

  def note_params
    params(:note).permit(
      :title,
      :content
    )
  end
end
