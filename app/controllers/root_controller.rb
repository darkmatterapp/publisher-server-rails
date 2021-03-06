class RootController < ApplicationController
  def index
    if setting('home_page').present?

      @post = Post.of(:page).find_by(slug: setting('home_page'))

      # no layout
      if @post.post_type.hide_layout?
        render text: @post.content, layout: false
      else
        @page_title = @post.name
        render '/posts/show'
      end

    else

      @slug = 'home'
      @posts = Post.where.not(post_type_type: 'Page').for_user(current_user).page(params[:page]).per_page(5)
      render 'posts/index'

    end
  end
end
