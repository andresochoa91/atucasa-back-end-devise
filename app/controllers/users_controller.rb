class UsersController < ApplicationController
    def show
        render ({
            json: {
                message: "Success",
                user: {
                    id: current_user.id,
                    email: current_user.email
                }
            },
            status: 200
        })
    end
end
