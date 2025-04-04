import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["minPrice", "maxPrice", "minRange", "maxRange", "productList"];

  updatePrice() {
    // Ensure values are updated correctly as per input range
    this.minPriceTarget.textContent = `$${this.minRangeTarget.value}`;
    this.maxPriceTarget.textContent = `$${this.maxRangeTarget.value}+`;
  }

  async applyFilter() {
    const minPrice = this.minRangeTarget.value;
    const maxPrice = this.maxRangeTarget.value;

    const url = new URL(window.location.href);
    url.searchParams.set("min_price", minPrice);
    url.searchParams.set("max_price", maxPrice);

    try {
      const response = await fetch(url.toString(), {
        method: "GET", 
        headers: {
          "Accept": "text/vnd.turbo-stream.html" // Ensure Turbo handles the response
        }
      });

      if (response.ok) {
        // Replace content of the product list with the response
        this.productListTarget.innerHTML = await response.text();
      } else {
        console.error("Failed to fetch filtered products.");
      }
    } catch (error) {
      console.error("Error fetching filtered products:", error);
    }
  }
}
