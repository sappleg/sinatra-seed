require_relative 'route'

module Ottoman
    class CommentRoutes < Route

        Route.get '/mdus/:id/comments/', :auth => [['good_standing'], ['staff']] do
            begin
                if comments = Comment.fetch_all_from_mdu(settings.id, params[:id])
                    status 200
                    Comment.construct_json(comments)
                else
                    # TODO: raise some error
                end
            rescue => e
                ap e
            end
        end

        Route.post '/mdus/:id/comments/', :auth => [['good_standing'], ['staff']] do
            begin
                # TODO: perform validations
                Comment.create_for_mdu(settings.id, params[:id], get_data)
            rescue => e
                ap e
            end
        end

        Route.get '/mdus/:id/comments/:comment_id', :auth => [['good_standing'], ['staff']] do
            begin
                raise NonExistingComment unless comment = Comment.fetch(settings.id, params[:id], params[:comment_id])
                return comment.construct_json
            rescue => e
                error e.status, e
            end
        end

        Route.put '/mdus/:id/comments/:comment_id', :auth => [['good_standing'], ['staff']] do
            return 'comment does not exist' unless comment = Comment.fetch(settings.id, params[:id], params[:comment_id])

            comment.text = get_data[:text]
            if comment.user_id == settings.id
                comment.save
            else
                'not your comment'
            end
        end

        Route.delete '/mdus/:id/comments/:comment_id', :auth => [['good_standing'], ['staff']] do
            return 'comment does not exist' unless comment = Comment.fetch(settings.id, params[:id], params[:comment_id])

            if comment.user_id == settings.id
                # TODO: try catch block needed
                begin
                    comment.delete
                rescue => e
                    ap e
                end
            else
                # TODO: raise a not-your-comment-error
                'not your comment'
            end
        end
    end
end
