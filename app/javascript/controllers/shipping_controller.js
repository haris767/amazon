import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
 

  connect() {
    console.log('shipping modal')


    // Listen for shipping updates
    document.addEventListener("update-shipping", this.updateShipping.bind(this));
  }
   toggleShippingModal() {
    document.getElementById("shipping").click();
     
  }
  updateShipping(event) {
    const { shippingCost, totalPrice } = event.detail;

    console.log("Shipping updated:", { shippingCost, totalPrice });

    // Ensure we are updating elements inside the shipping modal
    const modal = document.getElementById("shipping_modal"); // Change ID if needed
    if (!modal) {
      console.error("Error: shipping modal not found.");
      return;
    }

    const shippingCostSpan = modal.querySelector("#shipping-cost");
    const totalPriceSpan = modal.querySelector("#total-price");

    if (shippingCostSpan) {
      shippingCostSpan.textContent = `$${shippingCost.toFixed(2)}`;
    } else {
      console.error("Error: #shipping-cost element not found inside modal.");
    }

    if (totalPriceSpan) {
      totalPriceSpan.textContent = `$${totalPrice.toFixed(2)}`;
    } else {
      console.error("Error: #total-price element not found inside modal.");
    }
  }
     
}