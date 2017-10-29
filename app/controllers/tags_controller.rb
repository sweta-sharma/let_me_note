class TagsController < ApplicationController
  def index
    render json: { tags: current_user.notes.map(&:tags).flatten.uniq.map{ |tag| format_tag(tag) } }
  end

  # def notes
  #   tag = Tag.find_by_id(params[:id])
  #   if tag.present?
  #     notes = tag.user_notes(current_user).map{ |note| format_note(note) }
  #     render json: { notes: notes }
  #   else
  #     render json: { error: 'invalid tag' }
  #   end
  # end
end
