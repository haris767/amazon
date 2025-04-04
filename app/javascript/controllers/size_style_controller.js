import { Controller } from "@hotwired/stimulus";
//old version
export default class extends Controller {
  static targets = ["image"];

  connect() {
    console.log("SizeStyleController connected!");
    this.selectedStyle = "";
    this.selectedSize = "";
    this.productId = this.element.dataset.productId; // Get product ID
    console.log("Product ID:", this.productId);
  }

  changeImage(event) {
    console.log("Event Triggered:", event.type);
    console.log("Target Element:", event.currentTarget);

    const button = event.currentTarget;
    let imageName = "";

    // If a thumbnail image is clicked
    if (button.tagName === "IMG") {
      console.log("Thumbnail clicked! Updating main image.");
      this.updateMainImage(button.src);
      return;
    }
  // Check if the clicked button has a size or style dataset
  if (button.dataset.size) {
    this.selectedSize = button.dataset.size.toLowerCase();
    console.log("📌 Selected Size:", this.selectedSize);
  }

  if (button.dataset.style) {
    this.selectedStyle = button.dataset.style.toLowerCase();
    console.log("📌 Selected Style:", this.selectedStyle);
  }

  // Construct image name dynamically based on selection
  if (this.selectedSize && this.selectedStyle) {
    imageName = `product_${this.productId}_${this.selectedSize}_${this.selectedStyle}.jpg`;
  } else if (this.selectedSize) {
    imageName = `product_${this.productId}_${this.selectedSize}.jpg`;
  } else if (this.selectedStyle) {
    imageName = `product_${this.productId}_${this.selectedStyle}.jpg`;
  }

  if (imageName) {
    fetch(`/products/${this.productId}/get_image?image_name=${imageName}`)
      .then(response => response.json())
      .then(data => {
        if (data.image_url) {
          console.log("Fetched Image URL:", data.image_url);
          this.updateMainImage(data.image_url);
        } else {
          console.error("Image not found:", imageName);
        }
      })
      .catch(error => console.error("Error fetching image:", error));
  }
}

  updateMainImage(newSrc) {
    // Find the main product image (not the thumbnails)
    const mainImage = this.imageTargets.find(img => img.classList.contains("main-product-image"));
    
    if (mainImage) {
      console.log("Updating Main Image Source:", newSrc);
      mainImage.src = newSrc;
    } else {
      console.error("Main product image not found! Ensure it has the class 'main-product-image'.");
    }
  }
}
//to pass size and style to cart page
document.querySelectorAll(".size-btn").forEach(button => {
  button.addEventListener("click", function () {
      document.querySelectorAll(".size-btn").forEach(btn => btn.classList.remove("active"));
      this.classList.add("active");
  });
});

document.querySelectorAll(".style-btn").forEach(button => {
  button.addEventListener("click", function () {
      document.querySelectorAll(".style-btn").forEach(btn => btn.classList.remove("active"));
      this.classList.add("active");
  });
});
