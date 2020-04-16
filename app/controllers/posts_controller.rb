class PostsController < ApplicationController
    before_action :require_login, only: [:create, :destroy]
    def index
        @posts = Post.all
        render json: { posts: @posts }
    end

    def user_index
        return unless set_user
        @posts = Post.where(creator_id: @user.id)
        api_render result: {posts: @posts}
    end

    def create
        @post = Post.new(post_params)
        @post.creator = @user_current

        unless @post.valid?
            return render json: { error: @post.errors }
        end

        @post.save
        render json: { post: @post }, status: 201
    end

    def update
        return unless set_post

        unless @post.update( post_params )
            return api_render errors: @post.errors, code: 400, status: false
        end

        api_render result: {post: @post}
    end

    def destroy
        return unless set_post

        @post.destroy
        api_render
    end

    private
    def post_params
        params.require(:post).permit(:title, :text, :original_text)
    end

    def set_user
        @user = User.find_by(username: params[:user_username])

        unless @user
            api_render errors: { user: ['not found'] }, status: false, code: 404
            return false
        end

        true
    end

    def set_post
        @post = Post.find_by(id: params[:id])

        unless @post
            api_render errors: { post: ['not found'] }, status: false, code: 404
            return false
        end

        true
    end

end
