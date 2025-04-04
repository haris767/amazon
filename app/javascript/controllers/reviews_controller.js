import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { productId: Number }; // Define productId value

  connect(){
    console.log('hello')
  }
  toggleReviewsModal(event) {
    const productId = this.productIdValue;
    const modal = document.getElementById(`reviews_${productId}`);

    if (modal) {
      modal.click(); // Open the correct modal
    }
  }
}
