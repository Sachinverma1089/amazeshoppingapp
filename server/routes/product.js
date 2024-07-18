const express = require("express");
const productRouter=express.Router();
const auth=require('../middlewares/auth.middlewares.js')
const {Product}=require('../models/product.js');


productRouter.get('/api/products/',auth,async(req,res)=>{
    try {
        
        const products=await Product.find({category:req.query.category});
        res.json(products);
        
    } catch (error) {
        res.status(500).json({error:error.message});
    }
});


// create a get request to search products and get them

productRouter.get('/api/products/search/:name',auth,async(req,res)=>{
    try {
        
        const products=await Product.find({
            name:{$regex:req.params.name,$options:"i"},
        });
        
        res.json(products);
        
    } catch (error) {
        res.status(500).json({error:error.message});
    }
});

//create a post request route to rate the product.
productRouter.post('/api/rate-product',auth,async(req,res)=>{
    try {
        const {id,rating}=req.body;
        let product = await Product.findById(id);

        for(let i=0;i<product.ratings.length;i++){
            if(product.ratings[i].userId == req.user){
                product.ratings.splice(i,1);
                break;
            }
        }

        const ratingSchema={
            userid:req.user,
            rating,
        }
        
        product.ratings.push(ratingSchema);
        product=await product.save();
        res.json(product);
        

    } catch (error) {
        res.status(500).json({error:error.message});
        
    }

})


productRouter.get('/api/deal-of-day',auth,async(req,res)=>{
    try {
        let products = await Product.find({});
       products= products.sort((product1,product2)=>{
            let product1Sum=0;
            let product2Sum=0;

            for(let i=0;i<product1.ratings.length;i++){
                product1Sum+=product1.ratings[i].rating;

            }
            for(let i=0;i<product2.ratings.length;i++){
                product2Sum+=product2.ratings[i].rating;

            }
            return product1Sum<product2Sum?1:-1;
        });
        res.json(products[0]);
        
    } catch (error) {
        res.status(500).json({error:error.message});
        
    }
})

module.exports=productRouter;

