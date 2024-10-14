const mongoose = require("mongoose");
const { productSchema } = require("./product");

const userSchema = mongoose.Schema({
  name: {
    required: true,
    type: String,
    trim: true,
  },
  email: {
    required: true,
    type: String,
    trim: true,
    validate: {
      validator: (value) => {
        const re =
          /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
        return value.match(re);
      },
      message: "Please enter a valid email address",
    },
  },
  password: {
    required: true,
    type: String,
  },
  address: {
    type: String,
    default: "",
  },
  type: {
    required: true,
    type: String,
    enum: ["Buyer", "Seller"],
  },
  phoneNumber: {
    type: String,
    required: true,
    validate: {
      validator: (value) => {
        const re = /^\d{10}$/; 
        return re.test(value);
      },
      message: "Phone number must be exactly 10 digits long",
    },
  },
  gstNumber: {
    type: String,
    required: function () {
      return this.type === "Seller";
    },
  },
  businessSector: {
    type: String,
    required: function () {
      return this.type === "Seller";
    },
  },
  cart: [
    {
      product: productSchema,
      quantity: {
        type: Number,
        required: true,
      },
    },
  ],
});

const User = mongoose.model("User", userSchema);
module.exports = User;
