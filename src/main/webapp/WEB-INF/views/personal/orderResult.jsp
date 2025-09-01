<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">
  <title>Order Confirmation - NiceShop Bootstrap Template</title>
  <meta name="description" content="">
  <meta name="keywords" content="">

<!-- ✅ 수정: 상대경로 → c:url 절대경로 -->
<link href="<c:url value='/assets/img/favicon.png' />" rel="icon">
<link href="<c:url value='/assets/img/apple-touch-icon.png' />" rel="apple-touch-icon">

<link href="<c:url value='/assets/vendor/bootstrap/css/bootstrap.min.css' />" rel="stylesheet">
<link href="<c:url value='/assets/vendor/bootstrap-icons/bootstrap-icons.css' />" rel="stylesheet">
<link href="<c:url value='/assets/vendor/swiper/swiper-bundle.min.css' />" rel="stylesheet">
<link href="<c:url value='/assets/vendor/aos/aos.css' />" rel="stylesheet">
<link href="<c:url value='/assets/vendor/glightbox/css/glightbox.min.css' />" rel="stylesheet">
<link href="<c:url value='/assets/vendor/drift-zoom/drift-basic.css' />" rel="stylesheet">

<link href="<c:url value='/assets/css/main.css' />" rel="stylesheet">

</head>

<body class="order-confirmation-page">

  <header id="header" class="header sticky-top">
    <!-- Top Bar -->
    <div class="top-bar py-2">
      <div class="container-fluid container-xl">
        <div class="row align-items-center">
          <div class="col-lg-4 d-none d-lg-flex">
            <div class="top-bar-item">
              <i class="bi bi-telephone-fill me-2"></i>
              <span>Need help? Call us: </span>
              <a href="tel:"><!-- fill phone --></a>
            </div>
          </div>

          <div class="col-lg-4 col-md-12 text-center">
            <div class="announcement-slider swiper init-swiper">
              <script type="application/json" class="swiper-config">
                {
                  "loop": true,
                  "speed": 600,
                  "autoplay": { "delay": 5000 },
                  "slidesPerView": 1,
                  "direction": "vertical",
                  "effect": "slide"
                }
              </script>
              <div class="swiper-wrapper">
                <div class="swiper-slide"></div>
                <div class="swiper-slide"></div>
                <div class="swiper-slide"></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- Navigation -->
    <div class="header-nav">
      <div class="container-fluid container-xl position-relative">
        <nav id="navmenu" class="navmenu">
          <ul>
            <li><a href="index.html">Home</a></li>
            <li><a href="about.html">About</a></li>
            <li><a href="category.html">Category</a></li>
            <li><a href="product-details.html">Product Details</a></li>
            <li><a href="cart.html">Cart</a></li>
            <li><a href="checkout.html">Checkout</a></li>

            <li class="dropdown"><a href="#"><span>Dropdown</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
              <ul>
                <li><a href="#">Dropdown 1</a></li>
                <li class="dropdown"><a href="#"><span>Deep Dropdown</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
                  <ul>
                    <li><a href="#">Deep Dropdown 1</a></li>
                    <li><a href="#">Deep Dropdown 2</a></li>
                    <li><a href="#">Deep Dropdown 3</a></li>
                    <li><a href="#">Deep Dropdown 4</a></li>
                    <li><a href="#">Deep Dropdown 5</a></li>
                  </ul>
                </li>
                <li><a href="#">Dropdown 2</a></li>
                <li><a href="#">Dropdown 3</a></li>
                <li><a href="#">Dropdown 4</a></li>
              </ul>
            </li>

            <!-- Products Megamenu 1 -->
            <li class="products-megamenu-1"><a href="#"><span>Megamenu 1</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
              <!-- Mobile View -->
              <ul class="mobile-megamenu">
                <li><a href="#">Featured Products</a></li>
                <li><a href="#">New Arrivals</a></li>
                <li><a href="#">Sale Items</a></li>
                <li class="dropdown"><a href="#"><span>Clothing</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
                  <ul>
                    <li><a href="#">Men's Wear</a></li>
                    <li><a href="#">Women's Wear</a></li>
                    <li><a href="#">Kids Collection</a></li>
                    <li><a href="#">Sportswear</a></li>
                    <li><a href="#">Accessories</a></li>
                  </ul>
                </li>
                <li class="dropdown"><a href="#"><span>Electronics</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
                  <ul>
                    <li><a href="#">Smartphones</a></li>
                    <li><a href="#">Laptops</a></li>
                    <li><a href="#">Audio Devices</a></li>
                    <li><a href="#">Smart Home</a></li>
                    <li><a href="#">Accessories</a></li>
                  </ul>
                </li>
                <li class="dropdown"><a href="#"><span>Home &amp; Living</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
                  <ul>
                    <li><a href="#">Furniture</a></li>
                    <li><a href="#">Decor</a></li>
                    <li><a href="#">Kitchen</a></li>
                    <li><a href="#">Bedding</a></li>
                    <li><a href="#">Lighting</a></li>
                  </ul>
                </li>
                <li class="dropdown"><a href="#"><span>Beauty</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
                  <ul>
                    <li><a href="#">Skincare</a></li>
                    <li><a href="#">Makeup</a></li>
                    <li><a href="#">Haircare</a></li>
                    <li><a href="#">Fragrances</a></li>
                    <li><a href="#">Personal Care</a></li>
                  </ul>
                </li>
              </ul>

              <!-- Desktop View -->
              <div class="desktop-megamenu">
                <div class="megamenu-tabs">
                  <ul class="nav nav-tabs" id="productMegaMenuTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                      <button class="nav-link active" id="featured-tab" data-bs-toggle="tab" data-bs-target="#featured-content-1862" type="button" aria-selected="true" role="tab">Featured</button>
                    </li>
                    <li class="nav-item" role="presentation">
                      <button class="nav-link" id="new-tab" data-bs-toggle="tab" data-bs-target="#new-content-1862" type="button" aria-selected="false" tabindex="-1" role="tab">New Arrivals</button>
                    </li>
                    <li class="nav-item" role="presentation">
                      <button class="nav-link" id="sale-tab" data-bs-toggle="tab" data-bs-target="#sale-content-1862" type="button" aria-selected="false" tabindex="-1" role="tab">Sale</button>
                    </li>
                    <li class="nav-item" role="presentation">
                      <button class="nav-link" id="category-tab" data-bs-toggle="tab" data-bs-target="#category-content-1862" type="button" aria-selected="false" tabindex="-1" role="tab">Categories</button>
                    </li>
                  </ul>
                </div>

                <div class="megamenu-content tab-content">
                  <div class="tab-pane fade show active" id="featured-content-1862" role="tabpanel" aria-labelledby="featured-tab">
                    <div class="product-grid">
                      <div class="product-card">
                        <div class="product-image">
                          <img src="" alt="" loading="lazy"><!-- fill image -->
                        </div>
                        <div class="product-info">
                          <h5></h5>
                          <p class="price"></p>
                          <a href="#" class="btn-view">View Product</a>
                        </div>
                      </div>
                      <div class="product-card">
                        <div class="product-image">
                          <img src="" alt="" loading="lazy">
                        </div>
                        <div class="product-info">
                          <h5></h5>
                          <p class="price"></p>
                          <a href="#" class="btn-view">View Product</a>
                        </div>
                      </div>
                      <div class="product-card">
                        <div class="product-image">
                          <img src="" alt="" loading="lazy">
                        </div>
                        <div class="product-info">
                          <h5></h5>
                          <p class="price"></p>
                          <a href="#" class="btn-view">View Product</a>
                        </div>
                      </div>
                      <div class="product-card">
                        <div class="product-image">
                          <img src="" alt="" loading="lazy">
                        </div>
                        <div class="product-info">
                          <h5></h5>
                          <p class="price"></p>
                          <a href="#" class="btn-view">View Product</a>
                        </div>
                      </div>
                    </div>
                  </div>

                  <div class="tab-pane fade" id="new-content-1862" role="tabpanel" aria-labelledby="new-tab">
                    <div class="product-grid">
                      <div class="product-card">
                        <div class="product-image">
                          <img src="" alt="" loading="lazy">
                          <span class="badge-new"></span>
                        </div>
                        <div class="product-info">
                          <h5></h5>
                          <p class="price"></p>
                          <a href="#" class="btn-view">View Product</a>
                        </div>
                      </div>
                      <div class="product-card">
                        <div class="product-image">
                          <img src="" alt="" loading="lazy">
                          <span class="badge-new"></span>
                        </div>
                        <div class="product-info">
                          <h5></h5>
                          <p class="price"></p>
                          <a href="#" class="btn-view">View Product</a>
                        </div>
                      </div>
                      <div class="product-card">
                        <div class="product-image">
                          <img src="" alt="" loading="lazy">
                          <span class="badge-new"></span>
                        </div>
                        <div class="product-info">
                          <h5></h5>
                          <p class="price"></p>
                          <a href="#" class="btn-view">View Product</a>
                        </div>
                      </div>
                      <div class="product-card">
                        <div class="product-image">
                          <img src="" alt="" loading="lazy">
                          <span class="badge-new"></span>
                        </div>
                        <div class="product-info">
                          <h5></h5>
                          <p class="price"></p>
                          <a href="#" class="btn-view">View Product</a>
                        </div>
                      </div>
                    </div>
                  </div>

                  <div class="tab-pane fade" id="sale-content-1862" role="tabpanel" aria-labelledby="sale-tab">
                    <div class="product-grid">
                      <div class="product-card">
                        <div class="product-image">
                          <img src="" alt="" loading="lazy">
                          <span class="badge-sale"></span>
                        </div>
                        <div class="product-info">
                          <h5></h5>
                          <p class="price"><span class="original-price"></span></p>
                          <a href="#" class="btn-view">View Product</a>
                        </div>
                      </div>
                      <div class="product-card">
                        <div class="product-image">
                          <img src="" alt="" loading="lazy">
                          <span class="badge-sale"></span>
                        </div>
                        <div class="product-info">
                          <h5></h5>
                          <p class="price"><span class="original-price"></span></p>
                          <a href="#" class="btn-view">View Product</a>
                        </div>
                      </div>
                      <div class="product-card">
                        <div class="product-image">
                          <img src="" alt="" loading="lazy">
                          <span class="badge-sale"></span>
                        </div>
                        <div class="product-info">
                          <h5></h5>
                          <p class="price"><span class="original-price"></span></p>
                          <a href="#" class="btn-view">View Product</a>
                        </div>
                      </div>
                      <div class="product-card">
                        <div class="product-image">
                          <img src="" alt="" loading="lazy">
                          <span class="badge-sale"></span>
                        </div>
                        <div class="product-info">
                          <h5></h5>
                          <p class="price"><span class="original-price"></span></p>
                          <a href="#" class="btn-view">View Product</a>
                        </div>
                      </div>
                    </div>
                  </div>

                  <div class="tab-pane fade" id="category-content-1862" role="tabpanel" aria-labelledby="category-tab">
                    <div class="category-grid">
                      <div class="category-column">
                        <h4>Clothing</h4>
                        <ul>
                          <li><a href="#">Men's Wear</a></li>
                          <li><a href="#">Women's Wear</a></li>
                          <li><a href="#">Kids Collection</a></li>
                          <li><a href="#">Sportswear</a></li>
                          <li><a href="#">Accessories</a></li>
                        </ul>
                      </div>
                      <div class="category-column">
                        <h4>Electronics</h4>
                        <ul>
                          <li><a href="#">Smartphones</a></li>
                          <li><a href="#">Laptops</a></li>
                          <li><a href="#">Audio Devices</a></li>
                          <li><a href="#">Smart Home</a></li>
                          <li><a href="#">Accessories</a></li>
                        </ul>
                      </div>
                      <div class="category-column">
                        <h4>Home &amp; Living</h4>
                        <ul>
                          <li><a href="#">Furniture</a></li>
                          <li><a href="#">Decor</a></li>
                          <li><a href="#">Kitchen</a></li>
                          <li><a href="#">Bedding</a></li>
                          <li><a href="#">Lighting</a></li>
                        </ul>
                      </div>
                      <div class="category-column">
                        <h4>Beauty</h4>
                        <ul>
                          <li><a href="#">Skincare</a></li>
                          <li><a href="#">Makeup</a></li>
                          <li><a href="#">Haircare</a></li>
                          <li><a href="#">Fragrances</a></li>
                          <li><a href="#">Personal Care</a></li>
                        </ul>
                      </div>
                    </div>
                  </div>

                </div>
              </div><!-- End Products Mega Menu 1 Desktop View -->
            </li><!-- End Products Mega Menu 1 -->

            <!-- Products Megamenu 2 -->
            <li class="products-megamenu-2"><a href="#"><span>Megamenu 2</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
              <!-- Mobile View -->
              <ul class="mobile-megamenu">
                <li><a href="#">Women</a></li>
                <li><a href="#">Men</a></li>
                <li><a href="#">Kids'</a></li>
                <li class="dropdown"><a href="#"><span>Clothing</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
                  <ul>
                    <li><a href="#">Shirts &amp; Tops</a></li>
                    <li><a href="#">Coats &amp; Outerwear</a></li>
                    <li><a href="#">Underwear</a></li>
                    <li><a href="#">Sweatshirts</a></li>
                    <li><a href="#">Dresses</a></li>
                    <li><a href="#">Swimwear</a></li>
                  </ul>
                </li>
                <li class="dropdown"><a href="#"><span>Shoes</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
                  <ul>
                    <li><a href="#">Boots</a></li>
                    <li><a href="#">Sandals</a></li>
                    <li><a href="#">Heels</a></li>
                    <li><a href="#">Loafers</a></li>
                    <li><a href="#">Slippers</a></li>
                    <li><a href="#">Oxfords</a></li>
                  </ul>
                </li>
                <li class="dropdown"><a href="#"><span>Accessories</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
                  <ul>
                    <li><a href="#">Handbags</a></li>
                    <li><a href="#">Eyewear</a></li>
                    <li><a href="#">Hats</a></li>
                    <li><a href="#">Watches</a></li>
                    <li><a href="#">Jewelry</a></li>
                    <li><a href="#">Belts</a></li>
                  </ul>
                </li>
                <li class="dropdown"><a href="#"><span>Specialty Sizes</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
                  <ul>
                    <li><a href="#">Plus Size</a></li>
                    <li><a href="#">Petite</a></li>
                    <li><a href="#">Wide Shoes</a></li>
                    <li><a href="#">Narrow Shoes</a></li>
                  </ul>
                </li>
              </ul>

              <!-- Desktop View -->
              <div class="desktop-megamenu">
                <div class="megamenu-tabs">
                  <ul class="nav nav-tabs" role="tablist">
                    <li class="nav-item" role="presentation">
                      <button class="nav-link active" id="womens-tab" data-bs-toggle="tab" data-bs-target="#womens-content-1883" type="button" aria-selected="true" role="tab">WOMEN</button>
                    </li>
                    <li class="nav-item" role="presentation">
                      <button class="nav-link" id="mens-tab" data-bs-toggle="tab" data-bs-target="#mens-content-1883" type="button" aria-selected="false" tabindex="-1" role="tab">MEN</button>
                    </li>
                    <li class="nav-item" role="presentation">
                      <button class="nav-link" id="kids-tab" data-bs-toggle="tab" data-bs-target="#kids-content-1883" type="button" aria-selected="false" tabindex="-1" role="tab">KIDS</button>
                    </li>
                  </ul>
                </div>

                <div class="megamenu-content tab-content">
                  <div class="tab-pane fade show active" id="womens-content-1883" role="tabpanel" aria-labelledby="womens-tab">
                    <div class="category-layout">
                      <div class="categories-section">
                        <div class="category-headers">
                          <h4>Clothing</h4>
                          <h4>Shoes</h4>
                          <h4>Accessories</h4>
                          <h4>Specialty Sizes</h4>
                        </div>

                        <div class="category-links">
                          <div class="link-row">
                            <a href="#">Shirts &amp; Tops</a>
                            <a href="#">Boots</a>
                            <a href="#">Handbags</a>
                            <a href="#">Plus Size</a>
                          </div>
                          <div class="link-row">
                            <a href="#">Coats &amp; Outerwear</a>
                            <a href="#">Sandals</a>
                            <a href="#">Eyewear</a>
                            <a href="#">Petite</a>
                          </div>
                          <div class="link-row">
                            <a href="#">Underwear</a>
                            <a href="#">Heels</a>
                            <a href="#">Hats</a>
                            <a href="#">Wide Shoes</a>
                          </div>
                          <div class="link-row">
                            <a href="#">Sweatshirts</a>
                            <a href="#">Loafers</a>
                            <a href="#">Watches</a>
                            <a href="#">Narrow Shoes</a>
                          </div>
                          <div class="link-row">
                            <a href="#">Dresses</a>
                            <a href="#">Slippers</a>
                            <a href="#">Jewelry</a>
                            <a href="#"></a>
                          </div>
                          <div class="link-row">
                            <a href="#">Swimwear</a>
                            <a href="#">Oxfords</a>
                            <a href="#">Belts</a>
                            <a href="#"></a>
                          </div>
                          <div class="link-row">
                            <a href="#">View all</a>
                            <a href="#">View all</a>
                            <a href="#">View all</a>
                            <a href="#"></a>
                          </div>
                        </div>
                      </div>
                      <div class="featured-section">
                        <div class="featured-image">
                          <img src="" alt="">
                          <div class="featured-content">
                            <h3></h3>
                            <a href="#" class="btn-shop">Shop now</a>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>

                  <div class="tab-pane fade" id="mens-content-1883" role="tabpanel" aria-labelledby="mens-tab">
                    <div class="category-layout">
                      <div class="categories-section">
                        <div class="category-headers">
                          <h4>Clothing</h4>
                          <h4>Shoes</h4>
                          <h4>Accessories</h4>
                          <h4>Specialty Sizes</h4>
                        </div>

                        <div class="category-links">
                          <div class="link-row">
                            <a href="#">Shirts &amp; Polos</a>
                            <a href="#">Sneakers</a>
                            <a href="#">Watches</a>
                            <a href="#">Big &amp; Tall</a>
                          </div>
                          <div class="link-row">
                            <a href="#">Jackets &amp; Coats</a>
                            <a href="#">Boots</a>
                            <a href="#">Belts</a>
                            <a href="#">Slim Fit</a>
                          </div>
                          <div class="link-row">
                            <a href="#">Underwear</a>
                            <a href="#">Loafers</a>
                            <a href="#">Ties</a>
                            <a href="#">Wide Shoes</a>
                          </div>
                          <div class="link-row">
                            <a href="#">Hoodies</a>
                            <a href="#">Dress Shoes</a>
                            <a href="#">Wallets</a>
                            <a href="#">Extended Sizes</a>
                          </div>
                          <div class="link-row">
                            <a href="#">Suits</a>
                            <a href="#">Sandals</a>
                            <a href="#">Sunglasses</a>
                            <a href="#"></a>
                          </div>
                          <div class="link-row">
                            <a href="#">Activewear</a>
                            <a href="#">Slippers</a>
                            <a href="#">Hats</a>
                            <a href="#"></a>
                          </div>
                          <div class="link-row">
                            <a href="#">View all</a>
                            <a href="#">View all</a>
                            <a href="#">View all</a>
                            <a href="#"></a>
                          </div>
                        </div>
                      </div>
                      <div class="featured-section">
                        <div class="featured-image">
                          <img src="" alt="">
                          <div class="featured-content">
                            <h3></h3>
                            <a href="#" class="btn-shop">Shop now</a>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>

                  <div class="tab-pane fade" id="kids-content-1883" role="tabpanel" aria-labelledby="kids-tab">
                    <div class="category-layout">
                      <div class="categories-section">
                        <div class="category-headers">
                          <h4>Clothing</h4>
                          <h4>Shoes</h4>
                          <h4>Accessories</h4>
                          <h4>By Age</h4>
                        </div>

                        <div class="category-links">
                          <div class="link-row">
                            <a href="#">T-shirts &amp; Tops</a>
                            <a href="#">Sneakers</a>
                            <a href="#">Backpacks</a>
                            <a href="#">Babies (0-24 months)</a>
                          </div>
                          <div class="link-row">
                            <a href="#">Outerwear</a>
                            <a href="#">Boots</a>
                            <a href="#">Hats &amp; Caps</a>
                            <a href="#">Toddlers (2-4 years)</a>
                          </div>
                          <div class="link-row">
                            <a href="#">Pajamas</a>
                            <a href="#">Sandals</a>
                            <a href="#">Socks</a>
                            <a href="#">Kids (4-7 years)</a>
                          </div>
                          <div class="link-row">
                            <a href="#">Sweatshirts</a>
                            <a href="#">Slippers</a>
                            <a href="#">Gloves</a>
                            <a href="#">Older Kids (8-14 years)</a>
                          </div>
                          <div class="link-row">
                            <a href="#">Dresses</a>
                            <a href="#">School Shoes</a>
                            <a href="#">Scarves</a>
                            <a href="#"></a>
                          </div>
                          <div class="link-row">
                            <a href="#">Swimwear</a>
                            <a href="#">Sports Shoes</a>
                            <a href="#">Hair Accessories</a>
                            <a href="#"></a>
                          </div>
                          <div class="link-row">
                            <a href="#">View all</a>
                            <a href="#">View all</a>
                            <a href="#">View all</a>
                            <a href="#"></a>
                          </div>
                        </div>
                      </div>
                      <div class="featured-section">
                        <div class="featured-image">
                          <img src="" alt="">
                          <div class="featured-content">
                            <h3></h3>
                            <a href="#" class="btn-shop">Shop now</a>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>

                </div>
              </div><!-- End Products Mega Menu 2 Desktop View -->
            </li><!-- End Products Mega Menu 2 -->

            <li><a href="contact.html">Contact</a></li>
          </ul>
        </nav>
      </div>
    </div>

    <!-- Mobile Search Form -->
    <div class="collapse" id="mobileSearch">
      <div class="container">
        <form class="search-form">
          <div class="input-group">
            <input type="text" class="form-control" placeholder="Search for products">
            <button class="btn" type="submit">
              <i class="bi bi-search"></i>
            </button>
          </div>
        </form>
      </div>
    </div>

  </header>

  <main class="main">
    <!-- Page Title -->
    <div class="page-title light-background">
      <div class="container d-lg-flex justify-content-between align-items-center">
        <h1 class="mb-2 mb-lg-0">Order Confirmation</h1>
        <nav class="breadcrumbs">
          <ol>
            <li><a href="index.html">Home</a></li>
            <li class="current">Order Confirmation</li>
          </ol>
        </nav>
      </div>
    </div><!-- End Page Title -->

    <!-- Order Confirmation Section -->
    <section id="order-confirmation" class="order-confirmation section">
      <div class="container" data-aos="fade-up" data-aos-delay="100">
        <div class="order-confirmation-3">
          <div class="row g-0">
            <!-- Left sidebar with order summary -->
            <div class="col-lg-4 sidebar" data-aos="fade-right">
              <div class="sidebar-content">
                <div class="success-animation">
                  <i class="bi bi-check-lg"></i>
                </div>

                <div class="order-id">
                  <h4>Order #</h4>
                  <div class="order-date"></div>
                </div>

                <div class="order-progress">
                  <div class="stepper-container">
                    <div class="stepper-item completed">
                      <div class="stepper-icon">1</div>
                      <div class="stepper-text">Confirmed</div>
                    </div>
                    <div class="stepper-item current">
                      <div class="stepper-icon">2</div>
                      <div class="stepper-text">Processing</div>
                    </div>
                    <div class="stepper-item">
                      <div class="stepper-icon">3</div>
                      <div class="stepper-text">Shipped</div>
                    </div>
                    <div class="stepper-item">
                      <div class="stepper-icon">4</div>
                      <div class="stepper-text">Delivered</div>
                    </div>
                  </div>
                </div>

                <div class="price-summary">
                  <h5>Order Summary</h5>
                  <ul class="summary-list">
                    <li><span>Subtotal</span><span></span></li>
                    <li><span>Shipping</span><span></span></li>
                    <li><span>Tax</span><span></span></li>
                    <li class="total"><span>Total</span><span></span></li>
                  </ul>
                </div>

                <div class="delivery-info">
                  <h5>Delivery Information</h5>
                  <p class="delivery-estimate">
                    <i class="bi bi-calendar-check"></i>
                    <span></span>
                  </p>
                  <p class="shipping-method">
                    <i class="bi bi-truck"></i>
                    <span></span>
                  </p>
                </div>

                <div class="customer-service">
                  <h5>Need Help?</h5>
                  <a href="#" class="help-link">
                    <i class="bi bi-chat-dots"></i>
                    <span>Contact Support</span>
                  </a>
                  <a href="#" class="help-link">
                    <i class="bi bi-question-circle"></i>
                    <span>FAQs</span>
                  </a>
                </div>
              </div>
            </div>

            <!-- Main content area -->
            <div class="col-lg-8 main-content" data-aos="fade-in">
              <div class="thank-you-message">
                <h1></h1>
                <p></p>
              </div>

              <!-- Shipping details -->
              <div class="details-card" data-aos="fade-up">
                <div class="card-header">
                  <h3>
                    <i class="bi bi-geo-alt"></i>
                    Shipping Details
                  </h3>
                  <i class="bi bi-chevron-down toggle-icon"></i>
                </div>
                <div class="card-body">
                  <div class="row g-4">
                    <div class="col-md-6">
                      <div class="detail-group">
                        <label>Ship To</label>
                        <address>
                          <!-- fill receiver name --><br>
                          <!-- fill address line 1 --><br>
                          <!-- fill city/zip --><br>
                          <!-- fill country -->
                        </address>
                      </div>
                    </div>
                    <div class="col-md-6">
                      <div class="detail-group">
                        <label>Contact</label>
                        <div class="contact-info">
                          <p><i class="bi bi-envelope"></i> </p>
                          <p><i class="bi bi-telephone"></i> </p>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Payment details -->
              <div class="details-card" data-aos="fade-up">
                <div class="card-header">
                  <h3>
                    <i class="bi bi-credit-card"></i>
                    Payment Details
                  </h3>
                  <i class="bi bi-chevron-down toggle-icon"></i>
                </div>
                <div class="card-body">
                  <div class="payment-method">
                    <div class="payment-icon">
                      <i class="bi bi-credit-card-2-front"></i>
                    </div>
                    <div class="payment-details">
                      <div class="card-type"></div>
                      <div class="card-number"></div>
                    </div>
                  </div>
                  <div class="billing-address mt-4">
                    <h5>Billing Address</h5>
                    <p></p>
                  </div>
                </div>
              </div>

              <!-- Order items -->
              <div class="details-card" data-aos="fade-up">
                <div class="card-header">
                  <h3>
                    <i class="bi bi-bag-check"></i>
                    Order Items
                  </h3>
                  <i class="bi bi-chevron-down toggle-icon"></i>
                </div>
                <div class="card-body">
                  <!-- fill order items here -->
                </div>
              </div>

              <!-- Action buttons -->
              <div class="action-area" data-aos="fade-up">
                <div class="row g-3">
                  <div class="col-md-6">
                    <a href="#" class="btn btn-back">
                      <i class="bi bi-arrow-left"></i>
                      Return to Shop
                    </a>
                  </div>
                  <div class="col-md-6">
                    <a href="#" class="btn btn-account">
                      <span>View in Account</span>
                      <i class="bi bi-arrow-right"></i>
                    </a>
                  </div>
                </div>
              </div>

              <!-- Recommended products -->
              <div class="recommended" data-aos="fade-up">
                <h3>You Might Also Like</h3>
                <div class="row g-4">
                  <div class="col-6 col-md-4">
                    <div class="product-card">
                      <div class="product-image">
                        <img src="" alt="" loading="lazy">
                      </div>
                      <h5></h5>
                      <div class="product-price"></div>
                      <a href="#" class="btn btn-add-cart">
                        <i class="bi bi-plus"></i>
                        Add to Cart
                      </a>
                    </div>
                  </div>
                  <div class="col-6 col-md-4">
                    <div class="product-card">
                      <div class="product-image">
                        <img src="" alt="" loading="lazy">
                      </div>
                      <h5></h5>
                      <div class="product-price"></div>
                      <a href="#" class="btn btn-add-cart">
                        <i class="bi bi-plus"></i>
                        Add to Cart
                      </a>
                    </div>
                  </div>
                  <div class="col-6 col-md-4 d-none d-md-block">
                    <div class="product-card">
                      <div class="product-image">
                        <img src="" alt="" loading="lazy">
                      </div>
                      <h5></h5>
                      <div class="product-price"></div>
                      <a href="#" class="btn btn-add-cart">
                        <i class="bi bi-plus"></i>
                        Add to Cart
                      </a>
                    </div>
                  </div>
                </div>
              </div>

            </div><!-- /col-lg-8 -->
          </div>
        </div>
      </div>
    </section><!-- /Order Confirmation Section -->
  </main>

  <footer id="footer" class="footer dark-background">
    <div class="footer-main">
      <div class="container">
        <div class="row gy-4">
          <div class="col-lg-4 col-md-6">
            <div class="footer-widget footer-about">
              <a href="index.html" class="logo">
                <span class="sitename">NiceShop</span>
              </a>
              <p></p>

              <div class="social-links mt-4">
                <h5>Connect With Us</h5>
                <div class="social-icons">
                  <a href="#" aria-label="Facebook"><i class="bi bi-facebook"></i></a>
                  <a href="#" aria-label="Instagram"><i class="bi bi-instagram"></i></a>
                  <a href="#" aria-label="Twitter"><i class="bi bi-twitter-x"></i></a>
                  <a href="#" aria-label="TikTok"><i class="bi bi-tiktok"></i></a>
                  <a href="#" aria-label="Pinterest"><i class="bi bi-pinterest"></i></a>
                  <a href="#" aria-label="YouTube"><i class="bi bi-youtube"></i></a>
                </div>
              </div>
            </div>
          </div>

          <div class="col-lg-2 col-md-6 col-sm-6">
            <div class="footer-widget">
              <h4>Shop</h4>
              <ul class="footer-links">
                <li><a href="category.html">New Arrivals</a></li>
                <li><a href="category.html">Bestsellers</a></li>
                <li><a href="category.html">Women's Clothing</a></li>
                <li><a href="category.html">Men's Clothing</a></li>
                <li><a href="category.html">Accessories</a></li>
                <li><a href="category.html">Sale</a></li>
              </ul>
            </div>
          </div>

          <div class="col-lg-2 col-md-6 col-sm-6">
            <div class="footer-widget">
              <h4>Support</h4>
              <ul class="footer-links">
                <li><a href="support.html">Help Center</a></li>
                <li><a href="account.html">Order Status</a></li>
                <li><a href="shiping-info.html">Shipping Info</a></li>
                <li><a href="return-policy.html">Returns &amp; Exchanges</a></li>
                <li><a href="#">Size Guide</a></li>
                <li><a href="contact.html">Contact Us</a></li>
              </ul>
            </div>
          </div>

          <div class="col-lg-4 col-md-6">
            <div class="footer-widget">
              <h4>Contact Information</h4>
              <div class="footer-contact">
                <div class="contact-item">
                  <i class="bi bi-geo-alt"></i>
                  <span></span>
                </div>
                <div class="contact-item">
                  <i class="bi bi-telephone"></i>
                  <span></span>
                </div>
                <div class="contact-item">
                  <i class="bi bi-envelope"></i>
                  <span></span>
                </div>
                <div class="contact-item">
                  <i class="bi bi-clock"></i>
                  <span></span>
                </div>
              </div>

              <div class="app-buttons mt-4">
                <a href="#" class="app-btn">
                  <i class="bi bi-apple"></i>
                  <span>App Store</span>
                </a>
                <a href="#" class="app-btn">
                  <i class="bi bi-google-play"></i>
                  <span>Google Play</span>
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="footer-bottom">
      <div class="container">
        <div class="row gy-3 align-items-center">
          <div class="col-lg-6 col-md-12">
            <div class="copyright">
              <p>© <span>Copyright</span> <strong class="sitename">NiceShop</strong>. All Rights Reserved.</p>
            </div>
            <div class="credits mt-1">
              Designed by <a href="https://bootstrapmade.com/">BootstrapMade</a>
            </div>
          </div>

          <div class="col-lg-6 col-md-12">
            <div class="d-flex flex-wrap justify-content-lg-end justify-content-center align-items-center gap-4">
              <div class="payment-methods">
                <div class="payment-icons">
                  <i class="bi bi-credit-card" aria-label="Credit Card"></i>
                  <i class="bi bi-paypal" aria-label="PayPal"></i>
                  <i class="bi bi-apple" aria-label="Apple Pay"></i>
                  <i class="bi bi-google" aria-label="Google Pay"></i>
                  <i class="bi bi-shop" aria-label="Shop Pay"></i>
                  <i class="bi bi-cash" aria-label="Cash on Delivery"></i>
                </div>
              </div>

              <div class="legal-links">
                <a href="tos.html">Terms</a>
                <a href="privacy.html">Privacy</a>
                <a href="tos.html">Cookies</a>
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>
  </footer>

  <!-- Scroll Top -->
  <a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>

  <!-- Preloader -->
  <div id="preloader"></div>

  <!-- Vendor JS Files -->
<!-- ✅ 수정: 상대경로 → c:url 절대경로 -->
<script src="<c:url value='/assets/vendor/bootstrap/js/bootstrap.bundle.min.js' />"></script>
<script src="<c:url value='/assets/vendor/php-email-form/validate.js' />"></script>
<script src="<c:url value='/assets/vendor/swiper/swiper-bundle.min.js' />"></script>
<script src="<c:url value='/assets/vendor/aos/aos.js' />"></script>
<script src="<c:url value='/assets/vendor/glightbox/js/glightbox.min.js' />"></script>
<script src="<c:url value='/assets/vendor/drift-zoom/Drift.min.js' />"></script>
<script src="<c:url value='/assets/vendor/purecounter/purecounter_vanilla.js' />"></script>

<script src="<c:url value='/assets/js/main.js' />"></script>


</body>
</html>
