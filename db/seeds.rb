description = <<-DESCRIPTION
<h4 class="font-medium" tabindex="-1">About this item</h4>
<div>IMMERSIVE, 7.1 SURROUND SOUND — Heighten awareness with accurate positional audio that lets you pinpoint intuitively where every sound is coming from (only available on Windows 10 64-bit)
</div>
<p>TRIFORCE 50MM DRIVERS — Cutting-edge proprietary design that divides the driver into 3 parts for the individual tuning of highs, mids, and lows —producing brighter, clearer audio with richer highs and more powerful lows
ADVANCED PASSIVE NOISE CANCELLATION — Sturdy closed earcups fully cover ears to prevent noise from leaking into the headset, with its cushions providing a closer seal for more sound isolation —
LIGHTWEIGHT DESIGN WITH BREATHABLE FOAM EAR CUSHIONS — At just 240g, the headset features thicker headband padding and leatherette with memory foam ear cushions to provide maximum comfort
BENDABLE HYPERCLEAR CARDIOID MIC — An improved pickup pattern ensures more voice and less noise as it tapers off towards the mics back and sides, with the sweet spot easily placed at your mouth because of the mics bendable design
CROSS-PLATFORM COMPATIBILITY — Works with PC, Mac, PS4, Xbox One, Nintendo Switch via 3.5mm jack, enjoy unfair audio advantage across almost every platform. *Xbox One stereo adapter may be required, purchase separately
#1 SELLING PC GAMING PERIPHERALS BRAND IN THE U.S. — Source — Circana, Retail Tracking Service, U.S., Dollar Sales, Gaming Designed Mice, Keyboards, and PC Headsets, Jan. 2019- Dec. 2023 combined</p>
DESCRIPTION

# subcategory_images = {
#   "Jeans" => "subcategory_9.jpg",
#   "Tops" => "subcategory_10.jpg",
#   "Dresses" => "subcategory_11.jpg",
#   "Shoes" => "subcategory_12.jpg"
# }

# # Ensure there are categories in the database
# if Category.exists?
#   subcategory_images.each do |name, image_file|
#     subcategory = Subcategory.create!(
#       name: name,
#       category_id: '3' # Assigns a random category
#     )

#     image_path = Rails.root.join("app/assets/images/subcategory_images/#{image_file}")

#     if File.exist?(image_path)
#       subcategory.image.attach(
#         io: File.open(image_path),
#         filename: image_file,
#         content_type: "image/jpg"
#       )
#       puts "Attached image: #{image_file} to subcategory: #{name} (Category: #{subcategory.category_id})"
#     else
#       puts "Image file missing: #{image_path}"
#     end
#   end
# else
#   puts "No categories found! Please seed categories first."
# end

# product_images = {
#   "Razer BlackShark V2 X Gaming Headset: 7.1 Surround Sound - 50mm Drivers - Memory Foam Cushion - for PC, Mac, PS4, PS5, Switch" => "product_1.jpg",
#   "2.4GHz Wireless Gaming Headset for PC, Ps5, Ps4 - Lossless Audio USB & Type-C Ultra Stable Gaming Headphones with Flip Microphone" => "product_2.jpg",
#   "BENGOO G9000 Stereo Gaming Headset for PS4 PC Xbox One PS5 Controller, Noise Cancelling Over Ear Headphones" => "product_3.jpg"

# }

# # Ensure there are Subcategories in the database
# if Subcategory.exists?
#   product_images.each do |headline, image_file|
#     product = Product.create!(
#       headline: headline,
#       description: description,
#       country_code: Faker::Address.country_code,
#       company_name: 'Razer',
#       ear_placement: 'over ear',
#       form_factor: 'over ear',
#       impedance: '32 Ohm',
#       price: Money.from_amount(50, 'USD'),
#       reviews_count: rand(0..50),
#       average_final_rating: rand(1.0..5.0).round(1),
#       subcategory_id: '25' # Assigns a random category
#     )

#     image_path = Rails.root.join("app/assets/images/product_images/#{image_file}")

#     if File.exist?(image_path)
#       product.images.attach(
#         io: File.open(image_path),
#         filename: image_file,
#         content_type: "image/jpg"
#       )
#       puts "Attached image: #{image_file} to product: #{headline} (Subcategory: #{product.subcategory_id})"
#     else
#       puts "Image file missing: #{image_path}"
#     end

# #
# ((5..10).to_a.sample).times do
#      Review.create!({
#      content: Faker::Lorem.paragraph(sentence_count: 10),
#      fivestar_rating: (1..5).to_a.sample,
#      fourstar_rating: (1..5).to_a.sample,
#      threestar_rating: (1..5).to_a.sample,
#      twostar_rating: (1..5).to_a.sample,
#      onestar_rating: (1..5).to_a.sample,
#      product: product, # jo hum ne property ka fake data bnane ke liye use kia tha variable
#      user: User.all.sample
# })
# end
# end
# else
#   puts "No subcategory found! Please seed subcategory first."
# end

# style_pc = Style.find_or_create_by(name: "PC")
# style_playstation = Style.find_or_create_by(name: "PlayStation")
# style_xbox = Style.find_or_create_by(name: "Xbox")

#
# by id pass we can insert data
## Productstyle.create(product: product, style: Style.find(2), stock: 50)
#
# ########################subproducts creation#####################################
# Create or find styles
# style_pc = Style.find_or_create_by(name: "PC")
# style_playstation = Style.find_or_create_by(name: "PlayStation")
# style_xbox = Style.find_or_create_by(name: "Xbox")

# # Create or find sizes
# size_small = Size.find_or_create_by(name: "3.5mm")
# size_medium = Size.find_or_create_by(name: "USB")

# # Fetch product
# product = Product.find_by(id: 12)
# if product.nil?
#   puts "❌ Product with ID 12 not found! Please add the product first."
#   exit
# end

# # Define subproduct images
# subproduct_images = {
#   "Razer BlackShark V2 X Gaming Headset" => "subproduct_1.jpg",
#   "2.4GHz Wireless Gaming Headset" => "subproduct_2.jpg",
#   "BENGOO G9000 Stereo Gaming Headset" => "subproduct_3.jpg"
# }

# # Sizes & Styles available for subproducts
# sizes = [ size_small, size_medium ]
# styles = [ style_pc, style_playstation, style_xbox ]

# # Creating subproducts with different sizes & styles
# sizes.each do |size|
#   subproduct_images.each do |headline, image_file|
#     styles.each do |style|
#       subproduct = Subproduct.create!(
#         headline: headline,
#         description: 'IMMERSIVE 7.1 SURROUND SOUND',
#         country_name: Faker::Address.country,
#         company_name: 'Razer',
#         ear_placement: 'Over Ear',
#         form_factor: 'Over Ear',
#         impedance: '32 Ohm',
#         price_cents: rand(5000..10000),
#         price_currency: 'USD',
#         reviews_count: rand(0..50),
#         average_final_rating: rand(1.0..5.0).round(1),
#         discount_price: 10,
#         product: product,
#         size: size,   # ✅ Assign size
#         style: style  # ✅ Assign style
#       )

#       # Attach image if it exists
#       image_path = Rails.root.join("app/assets/images/subproduct_images/#{image_file}")
#       if File.exist?(image_path)
#         subproduct.images.attach(
#           io: File.open(image_path),
#           filename: image_file,
#           content_type: "image/jpg"
#         )
#         puts "✅ Attached image: #{image_file} to subproduct: #{headline} (Size: #{size.name}, Style: #{style.name})"
#       else
#         puts "⚠️ Image file missing: #{image_path}"
#       end

#       # Generate random reviews for each subproduct
#       rand(5..10).times do
#         Review.create!(
#           content: Faker::Lorem.paragraph(sentence_count: 10),
#           fivestar_rating: rand(1..5),
#           fourstar_rating: rand(1..5),
#           threestar_rating: rand(1..5),
#           twostar_rating: rand(1..5),
#           onestar_rating: rand(1..5),
#           subproduct: subproduct,
#           user: User.all.sample
#         )
#       end
#     end
#   end
# end

# puts "🎉 Seeding completed successfully!"

ShippingZone.create([ { name: 'In-City', rate: 5.0 },
                     { name: 'Out-City', rate: 10.0 },
                     { name: 'Out-of-Country', rate: 25.0 } ])
