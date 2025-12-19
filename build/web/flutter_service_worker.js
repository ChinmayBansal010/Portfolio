'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "53248ad5a95a1725a52f3967f931542e",
"assets/AssetManifest.bin.json": "39139d0e14a60893d35ca0ff674ef899",
"assets/AssetManifest.json": "3f9d7416d0bf650591d7b9f9104fa54a",
"assets/assets/animations/dev.json": "e5975efdc2316eb28e7d704d3b2889e3",
"assets/assets/animations/section_separator.json": "d303969c17a06a9232ee64c6d5f4a4ce",
"assets/assets/animations/splash_bg.json": "710ea56a1bbb2e73ea2598335270f594",
"assets/assets/animations/waving_hand.json": "1f97a149fbc4035ab05d6366044b2479",
"assets/assets/fonts/SpaceGrotesk-Bold.ttf": "52e5e29a7805a81bac01a170e45d103d",
"assets/assets/fonts/SpaceGrotesk-Medium.ttf": "518133df6fcaf4237f97187e2ea1019e",
"assets/assets/fonts/SpaceGrotesk-Regular.ttf": "778bb9a271006ab9d103287699611325",
"assets/assets/skillIcons/c.svg": "dccbba627a28ad855fc569bd8c0897d8",
"assets/assets/skillIcons/cloudinary.svg": "3cf9196862c44283497ddd0d3f329274",
"assets/assets/skillIcons/cpp.svg": "19585be7636b2c8668d2a5c97f267d2c",
"assets/assets/skillIcons/dart.svg": "20d7b82998ddc6f73a4310bf58e609df",
"assets/assets/skillIcons/fastapi.svg": "71e86fcbac5cce03163ec245b41eb3d1",
"assets/assets/skillIcons/figma.svg": "3b0fb69f67df8e1c5665644cc8f7a983",
"assets/assets/skillIcons/firebase.svg": "1da8d950e3f30a69d7c957c26238e1de",
"assets/assets/skillIcons/flask.svg": "9dfcd2d62100ca4f58106392b5c4e207",
"assets/assets/skillIcons/flutter.svg": "92199e1295daa401a178e23bcfc438c8",
"assets/assets/skillIcons/keras.svg": "7e87bfe5e6675c59955c47bb7e7d7919",
"assets/assets/skillIcons/matplotlib.svg": "c9dc68d514b41126a2ae10fd34952204",
"assets/assets/skillIcons/mediapipe.svg": "8c60cba667ca00195060471d0931b473",
"assets/assets/skillIcons/my-sql.svg": "bc3d03dd6edbeccd4d1bedf24f9d6b87",
"assets/assets/skillIcons/netlify.svg": "79fe760dd915192c01694cfedfefd735",
"assets/assets/skillIcons/numpy.svg": "d9d4a0fb78d41ee30532a14a7f01e921",
"assets/assets/skillIcons/pandas.svg": "53a422846aad44a999f8c0aded5ee64c",
"assets/assets/skillIcons/postgresql.svg": "227577cf02cd782c72fbd9523daa6cf3",
"assets/assets/skillIcons/python.svg": "4948e6764d2214fe0c09621c6defe06b",
"assets/assets/skillIcons/pytorch.svg": "2e9df2b58fcfbe0c27617a96c0a0fb3b",
"assets/assets/skillIcons/render.svg": "ddd5c4f339a4f6a635ce2a716a4cbf2d",
"assets/assets/skillIcons/sql.svg": "7a35346c13ed692c71c887e172979fe3",
"assets/assets/skillIcons/supabase.svg": "b7af816cfefaf3d61a2d9986ef4bb232",
"assets/assets/skillIcons/tensorflow.svg": "83a5879ce55899e4643f486b76f0f6f1",
"assets/FontManifest.json": "d14f260a258206e6ea924dc7496397b3",
"assets/fonts/MaterialIcons-Regular.otf": "3ba95e30f1cca8d72c5fed72444a1be5",
"assets/NOTICES": "8111b2b49c9e6b197d9bc80895f3bee7",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"favicon.png": "7932ad471568c453f641e28a45281906",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"flutter_bootstrap.js": "6389904fc9f31da75f04789c6dfb5dab",
"icons/Icon-192.png": "cdca2f832fe9e311d3a720c6c5a62a39",
"icons/Icon-512.png": "9ddd9d830fd9f102e7e6fd62bdb27035",
"icons/Icon-maskable-192.png": "cdca2f832fe9e311d3a720c6c5a62a39",
"icons/Icon-maskable-512.png": "9ddd9d830fd9f102e7e6fd62bdb27035",
"index.html": "80ae73141e874b206d9957172543da42",
"/": "80ae73141e874b206d9957172543da42",
"main.dart.js": "64ccfe8f714199b53d3d972cdd9b4354",
"manifest.json": "e74af8957b5899dc6da961caee768ec9",
"version.json": "009c9e65172e010890f7f65fde438006"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
