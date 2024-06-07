const User = require('../models/user');
const  { Thread, Comment , Reply , Categorie ,Report} = require('../models/forum');
 function info(rep,userId) {
    const is_author=(rep.author_id.toString()===userId.toString())
    const already = rep.upvoters.includes(userId) ? true : false;
    return {
        id:rep._id,
        is_author : is_author,
        already_liked : already,
        upvotes:rep.upvotes,
        numreplies:rep.replies.length,
        author_name:rep.author_name,
        author_photo:rep.author_photo,
        content:rep.content,
        created_at: rep.created_at,
        shares:rep.shares,
        reply_to : rep.reply_to
    }
}

function inforeply(rep,userId) {
    const is_author=(rep.author_id.toString()===userId.toString())
    const already = rep.upvoters.includes(userId) ? true : false;
    return {
        id:rep._id,
        is_author : is_author,
        already_liked : already,
        upvotes:rep.upvotes,
        author_name:rep.author_name,
        author_photo:rep.author_photo,
        content:rep.content,
        created_at: rep.created_at,
        reply_to : rep.reply_to
    }
}

 function infothread(rep,userId) {
    const is_author=(rep.author_id.toString()===userId.toString())
    const already = rep.upvoters.includes(userId) ? true : false
    return {
        id:rep._id,
        shares:rep.shares,
        is_author : is_author,
        already_liked : already,
        upvotes:rep.upvotes,
        numreplies:rep.replies.length,
        author_name:rep.author_name,
        author_photo:rep.author_photo,
        content:rep.content,
        title:rep.title,
        created_at: rep.created_at,
        reply_to : rep.reply_to,
        mark:rep.mark
    }
}

async function replies_of_comment(commentreplies,userId,i){
    let promises=[]
    for(let j=i*3;j<=i*3+2;j++){
        if(j<=(commentreplies.length-1)){
            promises.push(Reply.findOne({_id:commentreplies[j]})
                .then(reply => {
                    if (reply){return inforeply(reply,userId)}
                })
                .catch(error => {throw error}))
        }
    }
    return Promise.all(promises)
    .then(results => {
        return results.filter(data => data); 
    })
    .catch(error => {
        throw error;
    });
}

async function comments_of_thread(threadreplies,userId,i){
    let promises = []; 
    for(let j=i*6;j<=i*6+5;j++){
        if(j<=(threadreplies.length-1)){
            promises.push(Comment.findOne({_id:threadreplies[j]})
                .then (async comment => {
                    if (comment){
                        const somereplies=await replies_of_comment(comment.replies,userId,0)
                        const infoo=info(comment,userId)
                        return {...infoo,somereplies}
                    }
                })
                .catch(error => {throw error}))
    }
    }
    return Promise.all(promises)
    .then(results => {
        return results.filter(data => data); 
    })
    .catch(error => {
        throw error;
    });
}

async function threads_of_categorie(categoriethreads, userId, i) {
    let rep=[]
        for (let j = i * 6 ; j < i*6 +6 ; j++) {
            if (j <= (categoriethreads.length - 1)) {
                await Thread.findOne({_id: categoriethreads[j]})
                .then(async thread => {
                    if (thread) {
                        rep.push(infothread(thread, userId))
                    }
                })
                .catch(error => {
                    throw error
                });
            }
        }
        return rep
}


function timescore(lastLike) {
    return 4-Math.floor((Date.now() - lastLike)/(60*1000*30))
}

exports.post_thread = (req, res, next) => {
    User.findOne({ _id:req.auth.userId})
    .then(user => {
        if (!user){res.status(400).json({message:'who are u?'})}else {
            Categorie.findOne({title:req.body.categorie})
            .then(categorie => {
                if(!categorie){res.status(404).json({message:"categorie not found"})}else {
                    const thread = new Thread({
                        author_id:user._id,
                        author_name:user.name,
                        author_photo:user.photo,
                        upvoters: [user._id],
                        title: req.body.title,
                        content:req.body.content,
                        created_at: Date.now(),
                        reply_to:req.body.categorie,
                        replies:[], //comments
                        upvotes:1,
                        mark:3,
                        last_interaction:Date.now()
                    })
                    thread.save().then(thread =>{
                        categorie.threads.push({id:thread._id,mark:3})
                        categorie.save()
                        .then(()=>res.status(200).json({message:"success",id:thread._id}))
                        .catch(error => res.status(500).json({error}));
                        })
                    .catch(error => res.status(500).json({error}));
                }
            })
            .catch(error => res.status(500).json({error}));
        }
    })
    .catch(error => res.status(500).json({ error }));
};

exports.delete_thread = (req, res, next) => {
    User.findOne({ _id:req.auth.userId})
    .then(user => {
        if (!user){res.status(400).json({message:'who are u?'})}else {
            Thread.findOne ({ _id:req.body.id})
            .then(thread => {
                if (!thread){res.status(404).json({message:'thread does not exist?'})}else {
                    if (thread.author_id.toString()===user._id.toString()){
                        thread.content='[deleted]'
                        thread.author_name='[deleted]'
                        thread.author_photo='/images/default.jpg'
                        thread.title='[deleted]'
                        thread.save().then(()=>res.status(200).json({message:"success"}))
                        .catch(error => res.status(500).json({error}));        
                    }else {res.status(401).json({message:'not auth'})}
                }
            })
            .catch(error => res.status(500).json({ error }));
        }
    })
    .catch(error => res.status(500).json({ error }));
};

exports.like_thread  = (req, res, next) => {
    User.findOne({ _id:req.auth.userId})
    .then(user => {
        if (!user){res.status(400).json({message:'who are u?'})}else {
            Thread.findOne ({ _id:req.body.id})
            .then(async thread => {
                if (!thread){res.status(404).json({message:'thread does not exist?'})}else {
                    const already = thread.upvoters.findIndex(upvoterId => upvoterId.equals(user._id));
                    let lastmark=0;
                    if (already == -1){
                        thread.upvoters.push(user._id)
                        thread.upvotes++
                        thread.mark = (6*(thread.replies.length)+3*thread.upvotes)+timescore(thread.last_interaction)
                        lastmark=thread.mark
                        thread.last_interaction=Date.now()
                        await thread.save()        
                    } else {
                        thread.upvoters[already] = thread.upvoters[thread.upvoters.length-1]
                        thread.upvoters.pop()
                        thread.upvotes--
                        thread.mark = (6*(thread.replies.length)+3*thread.upvotes)+timescore(thread.last_interaction)
                        lastmark=thread.mark
                        thread.last_interaction=Date.now()
                        await thread.save()            
                    }
                    Categorie.findOne({title:thread.reply_to})
                    .then(async categorie=>{
                        if(categorie){
                            categorie.threads=categorie.threads.map(element=>{
                                if(element.id.equals(thread._id)){
                                    return{
                                        id:element.id,
                                        mark:lastmark,
                                        _id:element._id
                                    }
                                }else {
                                    return element
                                }
                            })
                            await categorie.save()
                            res.status(200).json({message:"success"})
                        }else{res.status(200).json({message:"impossible"})}
                    })
                    .catch(error => res.status(500).json({ error }));
                }
            })
            .catch(error => res.status(500).json({ error }));
        }
    })
    .catch(error => res.status(500).json({ error }));
};

exports.post_comment = (req, res, next) => {
    User.findOne({ _id:req.auth.userId})
    .then(user => {
        if (!user){res.status(400).json({message:'who are u?'})}else {
            Thread.findOne ({ _id:req.body.thread})
            .then(thread => {
                if (!thread){res.status(400).json({message:'thread not found'})} else {
                    const comment = new Comment({
                        author_id:user._id,
                        author_name:user.name,
                        author_photo:user.photo,
                        upvoters: [user._id],
                        content:req.body.content,
                        created_at: Date.now(),
                        reply_to : thread._id,
                        replies:[],
                        mark:3,
                        upvotes:1,
                        last_interaction:Date.now()
                    })
                    comment.save().then(async comment=>{
                        thread.replies.push({id:comment._id,mark:3})
                        thread.mark = (6*(thread.replies.length)+3*thread.upvotes)+timescore(thread.last_interaction)
                        const lastmark=thread.mark
                        thread.last_interaction=Date.now()
                        await thread.save()
                        Categorie.findOne({title:thread.reply_to})
                            .then(async categorie=>{
                                categorie.threads=categorie.threads.map(element=>{
                                    if(element.id.equals(thread._id)){
                                        return{
                                            id:element.id,
                                            mark:lastmark,
                                        }
                                    }else {
                                        return element
                                    }
                                })
                                await categorie.save()
                                res.status(200).json({message:"success"})
                            })
                            .catch(error => res.status(500).json({ error }));                 
                    })
                    .catch(error => res.status(500).json({error}));
                }
            })
            .catch(error => res.status(500).json({ error }));
        }
    })
    .catch(error => res.status(500).json({ error }));
};

exports.delete_comment = (req, res, next) => {
    User.findOne({ _id:req.auth.userId})
    .then(user => {
        if (!user){res.status(400).json({message:'who are u?'})}else {
            Comment.findOne ({ _id:req.body.id})
            .then(comment => {
                if (!comment){res.status(404).json({message:'comment does not exist'})}else {
                    if (comment.author_id.toString()===user._id.toString()){
                        comment.content='[deleted]'
                        comment.author_name='[deleted]'
                        comment.author_photo='/images/default.jpg'
                        comment.save().then(()=>res.status(200).json({message:"success"}))
                        .catch(error => res.status(500).json({error}));        
                    }else {res.status(401).json({message:'not auth'})}
                }
            })
            .catch(error => res.status(500).json({ error }));
        }
    })
    .catch(error => res.status(500).json({ error }));
};

exports.like_comment  = (req, res, next) => {
    User.findOne({ _id:req.auth.userId})
    .then(user => {
        if (!user){res.status(400).json({message:'who are u?'})}else {
            Comment.findOne ({ _id:req.body.id})
            .then(comment => {
                if (!comment){res.status(404).json({message:'comment does not exist?'})}else {
                    const already=comment.upvoters.findIndex(upvoterId => upvoterId.equals(user._id))
                    if (already == -1){
                        comment.upvoters.push(user._id)
                        comment.upvotes++
                        comment.mark = (6*(comment.replies.length)+3*comment.upvotes)+timescore(comment.last_interaction)
                        comment.last_interaction=Date.now()
                        Thread.findOne({_id:comment.reply_to})
                        .then(thread=>{
                            thread.replies.push({id:comment._id,mark:comment.mark})
                            thread.mark = (6*(thread.replies.length)+3*thread.upvotes)+timescore(thread.last_interaction)
                            thread.last_interaction=Date.now()
                            thread.save()
                            .then(()=>{
                                comment.save().then(()=>res.status(200).json({message:"success"}))
                                .catch(error => res.status(500).json({error}));        
                            })
                            .catch(error => res.status(500).json({error}));        
                        })
                        .catch(error => res.status(500).json({error}));        
                    } else {
                        comment.upvoters[already] = comment.upvoters[comment.upvoters.length-1]
                        comment.upvoters.pop()
                        comment.upvotes--
                        comment.mark = (6*(comment.replies.length)+3*comment.upvotes)+timescore(comment.last_interaction)
                        comment.last_interaction=Date.now()
                        Thread.findOne({_id:comment.reply_to})
                        .then(thread=>{
                            thread.replies.push({id:comment._id,mark:comment.mark})
                            thread.mark = (6*(thread.replies.length)+3*thread.upvotes)+timescore(thread.last_interaction)
                            thread.last_interaction=Date.now()
                            thread.save()
                            .then(()=>{
                                comment.save().then(()=>res.status(200).json({message:"success"}))
                                .catch(error => res.status(500).json({error}));        
                            })
                            .catch(error => res.status(500).json({error}));        
                        })
                        .catch(error => res.status(500).json({error}));            
                    }
                }
            })
            .catch(error => res.status(500).json({ error }));
        }
    })
    .catch(error => res.status(500).json({ error }));
};


exports.post_reply = (req, res, next) => {
    User.findOne({ _id:req.auth.userId})
    .then(user => {
        if (!user){res.status(400).json({message:'who are u?'})}else {
            if(req.body.comment){
                Comment.findOne ({ _id:req.body.comment})
                .then(comment => {
                    if (!comment){res.status(400).json({message:'comment not found'})} else {
                        const reply = new Reply({
                            author_id:user._id,
                            author_name:user.name,
                            author_photo:user.photo,
                            upvoters: [user._id],
                            upvotes:1,
                            content:req.body.content,
                            created_at: Date.now(),
                            reply_to:{
                                id:comment._id,
                                kind:'comment',
                                username:comment.author_name
                            }
                        })
                        reply.save().then(reply=>{
                            comment.replies.push(reply._id)
                            comment.mark = (6*(comment.replies.length)+3*comment.upvotes)+timescore(comment.last_interaction)
                            comment.last_interaction=Date.now()
                            comment.save().then(()=>res.status(200).json({message:"success",id:reply._id}))
                            .catch(error => res.status(500).json({error}));
                        })
                        .catch(error => res.status(500).json({error}));
                    }
                })
                .catch(error => res.status(500).json({ error }));
            }else {
                Reply.findOne ({ _id:req.body.reply})
                .then(reply => {
                    if (!reply){res.status(400).json({message:'reply not found'})} else {
                        const replyy = new Reply({
                            author_id:user._id,
                            author_name:user.name,
                            author_photo:user.photo,
                            upvoters: [user._id],
                            upvotes:1,
                            content:req.body.content,
                            created_at: Date.now(),
                            reply_to:{
                                id:reply._id,
                                kind:'reply',
                                username:reply.author_name
                            }
                        })
                        replyy.save()
                        .then(async replyy=>{
                            let r=reply
                            while (r.reply_to.kind  !=='comment'){
                                r = await Reply.findOne({_id:r.reply_to.id})
                                if (!r){res.status(500).json({ message:'call ahmed' })}
                            }
                            r=await Comment.findOne({_id:r.reply_to.id})
                            if (!r){res.status(500).json({ message:'call ahmed' })}
                            r.replies.push(replyy._id)
                            await r.save()
                            res.status(200).json({message:"success",id:replyy._id})})
                        .catch(error => res.status(500).json({ error }));
                    }
                })
                .catch(error => res.status(500).json({ error }));
            }
        }
    })
    .catch(error => res.status(500).json({ error }));
};

exports.delete_reply = (req, res, next) => {
    User.findOne({ _id:req.auth.userId})
    .then(user => {
        if (!user){res.status(400).json({message:'who are u?'})}else {
            Reply.findOne ({ _id:req.body.id})
            .then(reply => {
                if (!reply){res.status(404).json({message:'reply does not exist'})}else {
                    if (reply.author_id.toString()===user._id.toString()){
                        reply.content='[deleted]'
                        reply.author_name='[deleted]'
                        reply.author_photo='/images/default.jpg'
                        reply.save().then(()=>res.status(200).json({message:"success"}))
                        .catch(error => res.status(500).json({error}));        
                    }else {res.status(401).json({message:'not auth'})}
                }
            })
            .catch(error => res.status(500).json({ error }));
        }
    })
    .catch(error => res.status(500).json({ error }));
};

exports.like_reply  = (req, res, next) => {
    User.findOne({ _id:req.auth.userId})
    .then(user => {
        if (!user){res.status(400).json({message:'who are u?'})}else {
            Reply.findOne ({ _id:req.body.id})
            .then(reply => {
                if (!reply){res.status(404).json({message:'reply does not exist?'})}else {
                    const already=reply.upvoters.findIndex(upvoterId => upvoterId.equals(user._id))
                    if (already === -1){
                        reply.upvoters.push(user._id)
                        reply.upvotes++
                        reply.save().then(()=>res.status(200).json({message:"success"}))
                        .catch(error => res.status(500).json({error}));        
                    } else {
                        reply.upvoters[already] = reply.upvoters[reply.upvoters.length-1]
                        reply.upvoters.pop()
                        reply.upvotes--
                        reply.save().then(()=>res.status(200).json({message:"success"}))
                        .catch(error => res.status(500).json({error}));            
                    }
                }
            })
            .catch(error => res.status(500).json({ error }));
        }
    })
    .catch(error => res.status(500).json({ error }));
};

exports.get_replies  = (req, res, next) => { 
    User.findOne({ _id:req.auth.userId})
    .then(user => {
        if (!user){res.status(400).json({message:'who are u?'})}else {
            Comment.findOne({_id:req.query.id})
            .then(async comment => {
                if(!comment){res.status(404).json({message:"comment not found"})}else {
                    const replies=await replies_of_comment(comment.replies,user._id,req.query.i)
                    res.status(200).json({message:"success",replies_array:replies})
                }
            })
            .catch(error => res.status(500).json({ error }));
        }
    })
    .catch(error => res.status(500).json({ error }));
};

exports.get_comments  = (req, res, next) => { 
    User.findOne({ _id:req.auth.userId})
    .then(async user => {
        if (!user){res.status(400).json({message:'who are u?'})}else {
            const comments=await comments_of_thread(req.body.comments_array,user._id,req.query.i)
            res.status(200).json({
                message:"success",
                comments:comments})
        }
    })
    .catch(error => res.status(500).json({ error }));
};

exports.get_thread  = (req, res, next) => { 
    User.findOne({ _id:req.auth.userId})
    .then(user => {
        if (!user){res.status(400).json({message:'who are u?'})}else {
            Thread.findOne({_id:req.query.id})
            .then(async thread => {
                if(!thread){res.status(404).json({message:"thread not found"})}else {
                    thread.replies.sort((a, b) => b.mark - a.mark)
                    let comments_array = thread.replies.map(element => element.id)
                    const comments= await comments_of_thread(comments_array,user._id,0)
                    res.status(200).json({
                        message:"success",
                        thread:infothread(thread,user._id),
                        comments:comments,
                        comments_array:comments_array})
                }
            })
            .catch(error => res.status(500).json({ error }));
        }
    })
    .catch(error => res.status(500).json({ error }));
};

exports.get_categories = (req, res, next) => {
    User.findOne({ _id: req.auth.userId })
        .then(user => {
            if (!user) {
                return res.status(400).json({ message: 'who are u?' });
            } else {
                Categorie.find()
                    .then(async categories => {
                        
                        let rep = [];
                        let threads_array=[]
                        for (let i = 0; i < categories.length; i++) {
                            categories[i].threads.forEach(element => {threads_array.push({id:element.id,mark:element.mark,cat:categories[i].title})});
                            rep.push({
                                categorie: categories[i].title,
                                categorie_follows: categories[i].follows})
                        }
                        threads_array.sort((a, b) => b.mark - a.mark);
                        res.status(200).json({
                            message:'success',
                            catdata:rep,
                            data:threads_array
                        })
                    })
                    .catch(error => {
                        res.status(500).json({error });
                    });
            }
        })
        .catch(error => res.status(500).json({ error }));
};



exports.get_threads_of_categories  = (req, res, next) => { //req.body.data same from get categories
    User.findOne({ _id:req.auth.userId})
    .then(async user => {
        if (!user){res.status(400).json({message:'who are u?'})}else {
            const thth=req.body.data.filter(x=>req.body.categories.includes(x.cat))
            const threads_array=thth.map(e=>e.id)
            const threads = await threads_of_categorie(threads_array,user._id,req.query.i)
            res.status(200).json({
                message:"success",
                data:threads})
        }
    })
    .catch(error => res.status(500).json({ error }));
};

exports.report  = (req, res, next) => { 
    User.findOne({ _id:req.auth.userId})
    .then(user => {
        if (!user){res.status(400).json({message:'who are u?'})}else {
            Report.findOne({reported:req.body.reported})
            .then(report=>{
                if(!report){
                    const report=new Report({
                        description:[req.body.description],
                        model:req.body.model,
                        reported:req.body.reported,
                        reporters:[user._id],
                        reports:1
                    })
                    report.save()
                    .then(()=>res.status(200).json({message:"success"}))
                    .catch(error => res.status(500).json({ error }));
                }else {
                    if (report.reporters.includes(user._id)){
                        res.status(201).json({message:"already reported"})
                    }else {
                        report.reporters.push(user._id)
                        report.reports++
                        report.description.push(req.body,description)
                        report.save()
                        .then(()=>res.status(200).json({message:"success"}))
                        .catch(error => res.status(500).json({ error }));
                    }
                }
            })
            .catch(error => res.status(500).json({ error }));
        }
    })
    .catch(error => res.status(500).json({ error }));
};

exports.share_thread  = (req, res, next) => { 
    User.findOne({ _id:req.auth.userId})
    .then(user => {
        if (!user){res.status(400).json({message:'who are u?'})}else {
            Thread.findOne({ _id:req.query.id})
            .then(thread => {
                if (!thread){res.status(404).json({message:'thread not found'})}else {
                    thread.shares++
                    thread.save().then(()=>res.status(200).json({message:"success"})).catch(error => res.status(500).json({ error }));
                }
            })
            .catch(error => res.status(500).json({ error }));
        }
    })
    .catch(error => res.status(500).json({ error }));
};

exports.share_comment  = (req, res, next) => { 
    User.findOne({ _id:req.auth.userId})
    .then(user => {
        if (!user){res.status(400).json({message:'who are u?'})}else {
            Comment.findOne({ _id:req.query.id})
            .then(thread => {
                if (!thread){res.status(404).json({message:'comment not found'})}else {
                    thread.shares++
                    thread.save().then(()=>res.status(200).json({message:"success"})).catch(error => res.status(500).json({ error }));
                }
            })
            .catch(error => res.status(500).json({ error }));
        }
    })
    .catch(error => res.status(500).json({ error }));
};

exports.share_reply  = (req, res, next) => { 
    User.findOne({ _id:req.auth.userId})
    .then(user => {
        if (!user){res.status(400).json({message:'who are u?'})}else {
            Reply.findOne({ _id:req.query.id})
            .then(thread => {
                if (!thread){res.status(404).json({message:'reply not found'})}else {
                    thread.shares++
                    thread.save().then(()=>res.status(200).json({message:"success"})).catch(error => res.status(500).json({ error }));
                }
            })
            .catch(error => res.status(500).json({ error }));
        }
    })
    .catch(error => res.status(500).json({ error }));
};