import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button"];

  connect() {
    console.log("Stripe Checkout Stimulus Controller Connected");
  }

  async checkout() {
    try {
      const response = await fetch("/stripe_payments", { 
        method: "POST", 
        headers: { "Content-Type": "application/json" }
      });

      const data = await response.json();

      if (data.url) {
        window.location.href = data.url; // Redirect to Stripe Checkout
      } else {
        alert("Error creating Stripe session");
      }
    } catch (error) {
      console.error("Failed to fetch Stripe session:", error);
    }
  }
}
