const messageModel=require('../models/message')

const createMessage=async(req,res)=>{
    const senderId=req.auth.userId;
    const {chatId,text,status}=req.body

    const message=new messageModel({
        chatId,
        senderId,
        text,
        status,
    });
    try {
        const response=await message.save()
        res.status(200).json(response)
        
    } catch (error) {
        console.log(error)
        res.status(400).json(error)
    }
}


const getMessages=async(req,res)=>{
    const userId=req.auth.userId;
    const {chatId}=req.params;
    try {
        const messages=await messageModel.find({chatId});
        console.log('hi')
        
        // Iterate through each message
        for (let i = 0; i < messages.length; i++) {
            const message = messages[i];
            // Check if the senderId is not equal to userId
            if (message.senderId !== userId) {
                // Update the status to 'seen'
                await messageModel.findByIdAndUpdate(message._id, { status: 'seen' });
                // Update the message object in the messages array to reflect the change
                messages[i].status = 'seen';
               
            }
        }
        const msgs = messages.map(message => 
            {
            const msg={
                _id:message._id,
                chatId:message.chatId,
                text:message.text,
                status:message.status,
                byMe:message.senderId==userId,
                createdAt:message.createdAt,
            }
            return msg
            })

        
        res.status(200).json({msgs})
    } catch (error) {
        console.log(error)
        res.status(400).json(error)
    }
}


const updateMessage=async (req,res)=>{
    const id=req.params.messageId;
    console.log("iddd ",id);
    const m=await messageModel.findByIdAndUpdate(id,{status:"seen"},{new:true})
    return res.json({message:"seen"})
}

module.exports={createMessage,getMessages,updateMessage}