import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["deliveryButton", "modal", "countrySelect","zipInput", "cartButton"];

  connect() {
    console.log('delivery')
      console.log("Stimulus Connected: Delivery Controller");
    //   console.log("Zip Input Target:", this.hasZipInputTarget ? "Found" : "Not Found");
    //   console.log("Country Select Target:", this.hasCountrySelectTarget ? "Found" : "Not Found");
    
  }

  toggleDeliveryModal() {
    document.getElementById("delivery").click();
  }


updateDeliveryLocation(event) {
    // Get the selected country
    const selectedCountry = event.target.value;

   


    // Update all "Deliver to" buttons
    const deliveryButtons = document.querySelectorAll(".delivery_location");
    deliveryButtons.forEach(button => {
        button.textContent = selectedCountry;
    });
   // Check if the target exists in Stimulus scope, else find it manually
   let cartButton = this.hasCartButtonTarget ? this.cartButtonTarget : document.querySelector("[data-delivery-target='cartButton']");

   if (cartButton) {
       cartButton.classList.remove("hidden");
   } else {
       console.warn("❌ cartButton target not found. Ensure the button is inside the same controller scope.");
   }
    
    // Fetch elements safely
    const shippingMethodSelect = document.getElementById("shipping-method");
    const shippingCostSpan = document.getElementById("shipping-cost");
    const totalPriceSpan = document.getElementById("total-price");
    const estimatedDeliverySpan = document.getElementById("estimated-delivery");
    const productDetails = document.getElementById("product-details");
    const quantitySelect = document.getElementById("quantity"); // Quantity Selector
    if (!productDetails) {
        console.error("Error: #product-details element not found.");
        return;
    }

    const productId = productDetails.dataset.productId; // ✅ Get product ID
    const productPrice = parseFloat(productDetails.dataset.basePrice); // Get base price
    let selectedQuantity = parseInt(quantitySelect.value) || 1; // Default to 1
    fetch(`/update_shipping?country=${selectedCountry}&product_id=${productId}`) // ✅ Pass product_id
    .then(response => response.json())
    .then(data => {
        if (data.shipping_rates) {
            // ✅ Check for Free Shipping
            const freeShipping = data.shipping_rates.standard.cost === 0;

            // ✅ Update shipping method dropdown dynamically
            shippingMethodSelect.innerHTML = `
                <option value="standard">${freeShipping ? "Free" : "$" + data.shipping_rates.standard.cost} - Standard (Delivery by ${data.shipping_rates.standard.delivery_date})</option>
                <option value="expedited">${freeShipping ? "Free" : "$" + data.shipping_rates.expedited.cost} - Expedited (Delivery by ${data.shipping_rates.expedited.delivery_date})</option>
                <option value="same_day">${freeShipping ? "Free" : "$" + data.shipping_rates.same_day.cost} - Same-Day (Delivery by ${data.shipping_rates.same_day.delivery_date})</option>
            `;

            // ✅ Store shipping rates for later use
            this.shippingRates = data.shipping_rates;

            // ✅ Default to standard shipping
            const selectedMethod = shippingMethodSelect.value;
            const shippingCost = freeShipping ? 0 : this.shippingRates[selectedMethod].cost;
            const estimatedDelivery = this.shippingRates[selectedMethod].delivery_date;
            const totalPrice = productPrice + shippingCost;

            // ✅ Update UI
            if (shippingCostSpan) shippingCostSpan.textContent = freeShipping ? "Free" : `$${shippingCost.toFixed(2)}`;
            if (totalPriceSpan) totalPriceSpan.textContent = `$${totalPrice.toFixed(2)}`;
            if (estimatedDeliverySpan) estimatedDeliverySpan.textContent = `Delivery by ${estimatedDelivery}`;
            

            // ✅ Listen for changes in the shipping method dropdown
            shippingMethodSelect.addEventListener("change", (e) => {
                const method = e.target.value;
                const newShippingCost = freeShipping ? 0 : this.shippingRates[method].cost;
                const newEstimatedDelivery = this.shippingRates[method].delivery_date;
                const newTotalPrice = productPrice + newShippingCost;

                if (shippingCostSpan) shippingCostSpan.textContent = freeShipping ? "Free" : `$${newShippingCost.toFixed(2)}`;
                if (totalPriceSpan) totalPriceSpan.textContent = `$${newTotalPrice.toFixed(2)}`;
                if (estimatedDeliverySpan) estimatedDeliverySpan.textContent = `Delivery by ${newEstimatedDelivery}`;
            });

               
            //////////////////////////////////// Sharing Data with Other Script (shipping_controller.js) //////////////////////////////////////////
            const updateEvent = new CustomEvent("update-shipping", {
                detail: { shippingCost, totalPrice, estimatedDelivery },
                bubbles: true,
            });
            document.dispatchEvent(updateEvent); // Dispatch globally for use in shipping_controller.js
            //////////////////////////////////// Sharing Data with Other Script //////////////////////////////////////////
            // Initial calculation
            updateTotalPrice();

            // Listen for changes in the quantity dropdown
            quantitySelect.addEventListener("change", (e) => {
                selectedQuantity = parseInt(e.target.value) || 1;
                updateTotalPrice();
            });

    
        
       
        } else {
            console.error("Invalid shipping data:", data);
            if (shippingCostSpan) shippingCostSpan.textContent = "Error fetching shipping";
            if (estimatedDeliverySpan) estimatedDeliverySpan.textContent = "Error fetching delivery date";
        }
    
    })
    .catch(error => console.error("Error fetching shipping cost:", error));
}



updateCountryByZip(event) {
  event.preventDefault();
  
  let zipCode = this.zipInputTarget.value.trim();
  if (zipCode === "") return;

  console.log("ZIP Code Entered:", zipCode);

  fetch(`https://api.zippopotam.us/us/${zipCode}`)
      .then(response => response.json())
      .then(data => {
          console.log("API Response:", data);

          if (data && data.country) {
              let countryCode = data["country abbreviation"]; // Get 'US', 'CA', etc.
              
              if (this.hasCountrySelectTarget) {
                  this.countrySelectTarget.value = countryCode;  // Update dropdown value
                  this.countrySelectTarget.dispatchEvent(new Event("change")); // Trigger change event
              } else {
                  console.error("❌ Country select target not found.");
              }
          }
      })
      .catch(error => {
          console.error("❌ Error fetching ZIP code data:", error);
      });
}





buyProduct(e) {
    e.preventDefault();

    const shippingCost = document.getElementById("shipping-cost")?.textContent.replace("$", "").trim() || "0";
    const totalPrice = document.getElementById("total-price")?.textContent.replace("$", "").trim() || "0";
    const productId = e.target.dataset.productId;
    // const style = e.target.dataset.style;
    // const size = e.target.dataset.size;
    const baseURL = e.target.dataset.buyProductUrl;

    // Get the selected quantity from the dropdown
    const quantity = document.getElementById("quantity")?.value || "1";
     // Get the last selected size and style from buttons
     const selectedSize = document.querySelector(".size-btn.active")?.dataset.size || "3-5mm";
     const selectedStyle = document.querySelector(".style-btn.active")?.dataset.style || "PC";
    const paramsData = new URLSearchParams({
        product_id: productId,
        quantity: quantity,
        style: selectedStyle, // Use last selected style
        size: selectedSize, // Use last selected size
        shipping_cost: shippingCost,
        total_price: totalPrice
    });

    
    // Redirect to new.html.erb
    window.location.href = `/buy_product/new?${paramsData}`;


}



}


  
function updateTotalPrice() {
    const quantitySelect = document.getElementById("quantity");
    const totalPriceSpan = document.getElementById("total-price");
    const shippingCostSpan = document.getElementById("shipping-cost");

    // Ensure all required elements exist
    if (!quantitySelect || !totalPriceSpan || !shippingCostSpan) {
        console.error("Missing elements for price calculation.");
        return;
    }

    let selectedQuantity = parseInt(quantitySelect.value) || 1;
    let productPrice = parseFloat(document.getElementById("product-details").dataset.basePrice);
    let shippingCost = parseFloat(shippingCostSpan.textContent.replace("$", "")) || 0;

    let newTotalPrice = (productPrice * selectedQuantity) + shippingCost;

    // ✅ Update the total price in the UI
    totalPriceSpan.textContent = `$${newTotalPrice.toFixed(2)}`;
}




// buyProduct(e) {
//     e.preventDefault();

//     const paramsData = {
//       shipping_cost: this.shippingCost.value,//getting the shippingCost here
//       totalPrice: this.totalPrice.value,//getting the checkout date here
//     }

//     const paramsURL = (new URLSearchParams(paramsData)).toString();

//     const baseURL = e.target.dataset.buyProductUrl;
//     Turbo.visit(`${baseURL}?${paramsURL}`);//by this we navigate to buy_product/update_shipping.html.erb page on click
//   }
//   updateDeliveryLocation(event) {
//     // Get the selected country
//     const selectedCountry = event.target.value;

//     // Update all "Deliver to" buttons
//     const deliveryButtons = document.querySelectorAll(".delivery_location");
//     deliveryButtons.forEach(button => {
//         button.textContent = selectedCountry;
//     });

//     // Fetch elements safely
//     const shippingCostSpan = document.getElementById("shipping-cost");
//     const totalPriceSpan = document.getElementById("total-price");
//     const estimatedDeliverySpan = document.getElementById("estimated-delivery");
//     const productDetails = document.getElementById("product-details");

//     if (!productDetails) {
//         console.error("Error: #product-details element not found.");
//         return;
//     }

//     const productPrice = parseFloat(productDetails.dataset.basePrice); // Get base price from data attribute

//     fetch(`/update_shipping?country=${selectedCountry}`)
//     .then(response => response.json())
//     .then(data => {
//         if (data.shipping_cost && data.estimated_delivery) {
//             const shippingCost = parseFloat(data.shipping_cost); // Convert to number
//             const estimatedDelivery = data.estimated_delivery;
//             const totalPrice = productPrice + shippingCost; // Now `totalPrice` is defined

//             // Ensure elements exist before updating
//             if (shippingCostSpan) shippingCostSpan.textContent = `$${shippingCost.toFixed(2)}`;
//              document.getElementById("total-price").textContent = `$${totalPrice.toFixed(2)}`;
//             if (estimatedDeliverySpan) estimatedDeliverySpan.textContent = `Delivery by ${estimatedDelivery}`;

// ////////////////////////////////////sharing this script data to other script//////////////////////////////////////////
//               // Dispatch custom event for use this script data to other script(shipping_conroller.js)
//           const updateEvent = new CustomEvent("update-shipping", {
//             detail: { shippingCost, totalPrice },
//             bubbles: true,
//           });
        
//           document.dispatchEvent(updateEvent); // Dispatch globally for use this script data to other script(shipping_conroller.js)

//  ////////////////////////////////////sharing this script data to other script//////////////////////////////////////////
//         } else {
//             console.error("Invalid shipping data:", data);
//             if (shippingCostSpan) shippingCostSpan.textContent = "Error fetching shipping";
//             if (estimatedDeliverySpan) estimatedDeliverySpan.textContent = "Error fetching delivery date";
//         }
//     })
//     .catch(error => console.error("Error fetching shipping cost:", error));
// //old version
  
// }



//new with standard,expedited and same day delivery dates and its charges
// updateDeliveryLocation(event) {
//     // Get the selected country
//     const selectedCountry = event.target.value;

//     // Update all "Deliver to" buttons
//     const deliveryButtons = document.querySelectorAll(".delivery_location");
//     deliveryButtons.forEach(button => {
//         button.textContent = selectedCountry;
//     });

//     // Fetch elements safely
//     const shippingMethodSelect = document.getElementById("shipping-method");
//     const shippingCostSpan = document.getElementById("shipping-cost");
//     const totalPriceSpan = document.getElementById("total-price");
//     const estimatedDeliverySpan = document.getElementById("estimated-delivery");
//     const productDetails = document.getElementById("product-details");

//     if (!productDetails) {
//         console.error("Error: #product-details element not found.");
//         return;
//     }

//     const productPrice = parseFloat(productDetails.dataset.basePrice); // Get base price from data attribute

//     fetch(`/update_shipping?country=${selectedCountry}`)
//     .then(response => response.json())
//     .then(data => {
        
//         if (data.shipping_rates) {
//             // ✅ Store shipping rates
//             this.shippingRates = data.shipping_rates;

//             // ✅ Ensure the shipping method dropdown exists
//             if (!shippingMethodSelect) {
//                 console.error("Shipping method select element not found!");
//                 return;
//             }

//             // ✅ Populate shipping method dropdown dynamically
//             shippingMethodSelect.innerHTML = `
//                 <option value="standard">Standard - $${data.shipping_rates.standard.cost} (Delivery by ${data.shipping_rates.standard.delivery_date})</option>
//                 <option value="expedited">Expedited - $${data.shipping_rates.expedited.cost} (Delivery by ${data.shipping_rates.expedited.delivery_date})</option>
//                 <option value="same_day">Same-Day - $${data.shipping_rates.same_day.cost} (Delivery by ${data.shipping_rates.same_day.delivery_date})</option>
//             `;

//             // ✅ Default to standard shipping
//             const selectedMethod = shippingMethodSelect.value;
//             const shippingCost = this.shippingRates[selectedMethod].cost;
//             const estimatedDelivery = this.shippingRates[selectedMethod].delivery_date;
//             const totalPrice = productPrice + shippingCost;

//             // ✅ Update UI
//             if (shippingCostSpan) shippingCostSpan.textContent = `$${shippingCost.toFixed(2)}`;
//             if (totalPriceSpan) totalPriceSpan.textContent = `$${totalPrice.toFixed(2)}`;
//             if (estimatedDeliverySpan) estimatedDeliverySpan.textContent = `Delivery by ${estimatedDelivery}`;

//             // ✅ Listen for changes in the shipping method dropdown
//             shippingMethodSelect.addEventListener("change", (e) => {
//                 const method = e.target.value;
//                 const newShippingCost = this.shippingRates[method].cost;
//                 const newEstimatedDelivery = this.shippingRates[method].delivery_date;
//                 const newTotalPrice = productPrice + newShippingCost;

//                 if (shippingCostSpan) shippingCostSpan.textContent = `$${newShippingCost.toFixed(2)}`;
//                 if (totalPriceSpan) totalPriceSpan.textContent = `$${newTotalPrice.toFixed(2)}`;
//                 if (estimatedDeliverySpan) estimatedDeliverySpan.textContent = `Delivery by ${newEstimatedDelivery}`;
//             });

//             //////////////////////////////////// Sharing Data with Other Script (shipping_controller.js) //////////////////////////////////////////
//             const updateEvent = new CustomEvent("update-shipping", {
//                 detail: { shippingCost, totalPrice },
//                 bubbles: true,
//             });
//             document.dispatchEvent(updateEvent); // Dispatch globally for use in shipping_controller.js
//             //////////////////////////////////// Sharing Data with Other Script //////////////////////////////////////////
//         } else {
//             console.error("Invalid shipping data:", data);
//             if (shippingCostSpan) shippingCostSpan.textContent = "Error fetching shipping";
//             if (estimatedDeliverySpan) estimatedDeliverySpan.textContent = "Error fetching delivery date";
//         }
//     })
//     .catch(error => console.error("Error fetching shipping cost:", error));
// }



//free shipping with prime member implement in below script
 


// updateDeliveryLocation(event) {
//     // Get the selected country
//     const selectedCountry = event.target.value;

//     // Update all "Deliver to" buttons
//     const deliveryButtons = document.querySelectorAll(".delivery_location");
//     deliveryButtons.forEach(button => {
//         button.textContent = selectedCountry;
//     });

//     // Fetch elements safely
//     const shippingMethodSelect = document.getElementById("shipping-method");
//     const shippingCostSpan = document.getElementById("shipping-cost");
//     const totalPriceSpan = document.getElementById("total-price");
//     const estimatedDeliverySpan = document.getElementById("estimated-delivery");
//     const productDetails = document.getElementById("product-details");

//     if (!productDetails) {
//         console.error("Error: #product-details element not found.");
//         return;
//     }

//     const productPrice = parseFloat(productDetails.dataset.basePrice); // Get base price from data attribute

//     fetch(`/update_shipping?country=${selectedCountry}`)
//     .then(response => response.json())
//     .then(data => {
//         if (data.shipping_rates) {
//             // ✅ Check for Free Shipping
//             const freeShipping = data.shipping_rates.standard.cost === 0;

//             // ✅ Update shipping method dropdown dynamically
//             shippingMethodSelect.innerHTML = `
//                 <option value="standard">${freeShipping ? "Free" : "$" + data.shipping_rates.standard.cost} - Standard (Delivery by ${data.shipping_rates.standard.delivery_date})</option>
//                 <option value="expedited">${freeShipping ? "Free" : "$" + data.shipping_rates.expedited.cost} - Expedited (Delivery by ${data.shipping_rates.expedited.delivery_date})</option>
//                 <option value="same_day">${freeShipping ? "Free" : "$" + data.shipping_rates.same_day.cost} - Same-Day (Delivery by ${data.shipping_rates.same_day.delivery_date})</option>
//             `;

//             // ✅ Store shipping rates for later use
//             this.shippingRates = data.shipping_rates;

//             // ✅ Default to standard shipping
//             const selectedMethod = shippingMethodSelect.value;
//             const shippingCost = freeShipping ? 0 : this.shippingRates[selectedMethod].cost;
//             const estimatedDelivery = this.shippingRates[selectedMethod].delivery_date;
//             const totalPrice = productPrice + shippingCost;

//             // ✅ Update UI
//             if (shippingCostSpan) shippingCostSpan.textContent = freeShipping ? "Free" : `$${shippingCost.toFixed(2)}`;
//             if (totalPriceSpan) totalPriceSpan.textContent = `$${totalPrice.toFixed(2)}`;
//             if (estimatedDeliverySpan) estimatedDeliverySpan.textContent = `Delivery by ${estimatedDelivery}`;
//             const addToCartButton = document.getElementById("add-to-cart");
           

//             // ✅ Listen for changes in the shipping method dropdown
//             shippingMethodSelect.addEventListener("change", (e) => {
//                 const method = e.target.value;
//                 const newShippingCost = freeShipping ? 0 : this.shippingRates[method].cost;
//                 const newEstimatedDelivery = this.shippingRates[method].delivery_date;
//                 const newTotalPrice = productPrice + newShippingCost;
//                 const addToCartButton = document.getElementById("add-to-cart"); // 🔹 Select Add to Cart button

//                 if (!productDetails || !addToCartButton) {
//                     console.error("Error: Missing product details or Add to Cart button.");
//                     return;
//                 }
//                 if (shippingCostSpan) shippingCostSpan.textContent = freeShipping ? "Free" : `$${newShippingCost.toFixed(2)}`;
//                 if (totalPriceSpan) totalPriceSpan.textContent = `$${newTotalPrice.toFixed(2)}`;
//                 if (estimatedDeliverySpan) estimatedDeliverySpan.textContent = `Delivery by ${newEstimatedDelivery}`;

                
//             });

//             //////////////////////////////////// Sharing Data with Other Script (shipping_controller.js) //////////////////////////////////////////
//             const updateEvent = new CustomEvent("update-shipping", {
//                 detail: { shippingCost, totalPrice },
//                 bubbles: true,
//             });
//             document.dispatchEvent(updateEvent); // Dispatch globally for use in shipping_controller.js
//             //////////////////////////////////// Sharing Data with Other Script //////////////////////////////////////////
//         } else {
//             console.error("Invalid shipping data:", data);
//             if (shippingCostSpan) shippingCostSpan.textContent = "Error fetching shipping";
//             if (estimatedDeliverySpan) estimatedDeliverySpan.textContent = "Error fetching delivery date";
//         }
//     })
//     .catch(error => console.error("Error fetching shipping cost:", error));
// }

//free shipping with prime member implement in above script


