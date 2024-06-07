
all post
/auth/
    /send_otp
        req phone
        res 400 error :server
            503 error: twilio
    /verify_otp
        req phone,otp,data
        res 404 error : otp request not sent
            400 message : expired
            401 message : fail (otp not valid)
            200 message : success
    /signup
        req phone,email,password,name (user : categories / bib : com_reg_num address)
        res 401 error: phone not verified
            404 error :otp not verified
            400 error :email not sent
            500 error :server
            200 message :success
    /verify_email
        res 400 error :server
            401 error: user not found
            200 message :success
    /login
        req email,password
        res 400 error:incorrect
            401 message:not verified
            200 user,token
    /forgot_password
        req email
        res 401 error: user not found
            400 error: error email not sent
            500 error : server
            200 message : success
    /reset_password
        req email,otp,password
        res 401 error : expired
            402 error : otp incorrect
            500 error : server
            200 message : success
    /signout 
        res 200 message : success


/forum/
    /post_thread
        req title content categorie
        res 400 message : who are u?
    /delete_thread
        req id
        res 400 message : who are u?
            404 message : thread not found
            401 message : not auth ( you are not the author of this thread !)
        res 200 message : success
    /like_thread
        req id
        res 400 message : who are u?
            404 message : thread not found
        res 200 message : success
    /post_comment
        req content thread
        res 400 message : who are u?
    /delete_comment
        req id
        res 400 message : who are u?
            404 message : comment not found
            401 message : not auth ( you are not the author of this comment !)
        res 200 message : success
    /like_comment
        req id thread
        res 400 message : who are u?
            404 message : comment not found
        res 200 message : success
    /post_reply
        req content , comment OR reply (check for comment first)
        res 400 message : who are u?
    /delete_reply
        req id
        res 400 message : who are u?
            404 message : reply not found
            401 message : not auth ( you are not the author of this reply !)
        res 200 message : success
    /like_reply
        req id
        res 400 message : who are u?
            404 message : reply not found
        res 200 message : success

    /get_replies
        req.query: id i
        res 400 message : who are u?
            404 message : comment not found
        res 200 message : success
    /get_comments post 
        req.query.i   req.body.comments_array
        res 400 message : who are u?
        res 200 {message : success,
                comments:[comment+somereplies]}
    /get_thread
        req.query.id  
        res 400 message : who are u?
            404 message : thread not found
        res 200 {message : success,
                thread:{swal7ah},
                comments_array:[comment_id],
                comments:[comment+somereplies]}
    /get_categories
        res 400 message : who are u?
        res 200 {message : success,
                data:[{
                    categorie:title of categorie,
                    categorie_follows:integer,
                    threads_array:[thread_id],
                    threads:some threads
                }]}
    /get_threads_of_categories post
        req.body.categories: [string] : titles of categories selected by hbibna
        req.body.data: same data from res get_categories
        req.query.i
        res 400 message : who are u?
        res 200 {message : success,
                data:[{
                    categorie:categorie_title,
                    threads:some threads
                }]}
    /report
        req.body.reported (id)
        req.body.description
        req.body.model : thread or comment or reply
        res 400 message : who are u?
        res 201 {message : already reported}
        res 200 {message : success}
    /share_thread get
    /share_comment get
    /share_reply get
        req.query.id
        res 400 message : who are u?
        res 404 message : not found
        res 200 message : success

/profile/
    change_pp : post form-data file jpeg or jpg 
        res 200 {message : success}
    change_profile : post req.body. categories wilaya (optional for both )
        res 200 {message : success}
    delete_pp : delete 
        res 200 {message : success}


note : when a person deletes his pp , all the threads will point to a non existant picture so make sure to display images/default.jpg if the file pointed by thread.author.photo does not exist (do the extra check)