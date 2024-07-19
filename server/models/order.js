const mongoose = require('mongoose');
const { productSchema } = require('./product');


const orderSchema = mongoose.Schema({
    products:[
        {
            product:productSchema,
            quantity:{
                type:Number,
                required:true,
            }
        }
    ],
    totalPrice:{
        type:Number,
        required:true,
    },
    address:{
        type:String,
        required:true,
    },
    userId: {
        required: true,
        type: mongoose.Schema.Types.ObjectId, // Change to ObjectId
        ref: 'User' // Reference to the User model
    },
    orderedAt:{
        type:Date,
        default:Date.now,
        
    },
    status:{
        type:Number,
        default:0,
    }

});

const Order = mongoose.model('Order',orderSchema);
module.exports=Order;