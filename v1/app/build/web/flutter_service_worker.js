'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "11e1a177d57c5da2bc6e3a6acc3010f4",
"index.html": "2273e3d3d712ec292d6d1a5fc2fc9c13",
"/": "2273e3d3d712ec292d6d1a5fc2fc9c13",
"main.dart.js": "8aab54167d10e55e950c74365a088065",
"flutter.js": "f85e6fb278b0fd20c349186fb46ae36d",
"favicon.png": "ce55ffe7949114c21a362de0df4cc5ac",
"icons/Icon-192.png": "2c71acdf00b42323db242798c49e5a5f",
"icons/Icon-maskable-192.png": "2c71acdf00b42323db242798c49e5a5f",
"icons/Icon-maskable-512.png": "04e7cd0dc8526ed0a9031e7982a7a0dc",
"icons/Icon-512.png": "04e7cd0dc8526ed0a9031e7982a7a0dc",
"manifest.json": "73fb3b15e459ce558109415730c0d52a",
"assets/dotenv": "dfebc97db3f490280b4f73e28cfe27b3",
"assets/AssetManifest.json": "5d514dadce510baea045e1f6af94f8b2",
"assets/NOTICES": "48636ff024be833c08ded29d06a2121b",
"assets/FontManifest.json": "8adb80b1e2bd2c05e1a2d21664d04954",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/shaders/ink_sparkle.frag": "6666a5df6b97051354514282fd28fadc",
"assets/fonts/MaterialIcons-Regular.otf": "95db9098c58fd6db106f1116bae85a0b",
"assets/assets/images/flag.png": "5c92c364293f18bba357d98ed2f808bf",
"assets/assets/images/history.jpeg": "e0952111e393643d128548143d6f5d06",
"assets/assets/images/fuel.png": "f0f661b6708dbab9e8c73269c54fc696",
"assets/assets/images/tour_office.png": "deb491458d165d0f8b630ceab66b241c",
"assets/assets/images/distance.png": "c9706d8d79f4fbda08f2c751442ec796",
"assets/assets/images/fuel_map.png": "78095e551b0358eb8167d6f896effaac",
"assets/assets/images/tourism_staff/butaya.jpg": "f468d67e291a790b50badf5d4a36fe48",
"assets/assets/images/tourism_staff/husayan.jpg": "fe926fa81de86a8e72556fd0ef585d4f",
"assets/assets/images/tourism_staff/daanoy.jpg": "b0c003073d35d0563c5c902807d7dd05",
"assets/assets/images/tourism_staff/eralino.jpg": "9fef7c7d48ee584f343fc2d25eeac6d9",
"assets/assets/images/tourism_staff/apat.jpg": "dbe4d29606b2e3db2d6ce528047e6d27",
"assets/assets/images/tourism_staff/john_butaya.jpg": "66c6874cd1b8eec160a39dce401139a0",
"assets/assets/images/price.png": "4f6e2da652e07491c9c187ccb97b3b93",
"assets/assets/images/logo.png": "5213daf99d802d5e695fde7d4a2a1bef",
"assets/assets/images/lantapan_seal.png": "d81b0e62da79069968ec24bff14d2a69",
"assets/assets/images/launcher_icon.png": "9b40a2793722309f49029836fb8aa5f4",
"assets/assets/json/philippines.json": "09746a9c39deba614475252ac8d3fde1",
"assets/assets/fonts/VarelaRound-Regular.ttf": "6b7c705707eaa294409430419fd98efb",
"assets/assets/fonts/Tribal_Play.ttf": "4ff04f3d7758dc057f33cb9496b062cf",
"canvaskit/canvaskit.js": "2bc454a691c631b07a9307ac4ca47797",
"canvaskit/profiling/canvaskit.js": "38164e5a72bdad0faa4ce740c9b8e564",
"canvaskit/profiling/canvaskit.wasm": "95a45378b69e77af5ed2bc72b2209b94",
"canvaskit/canvaskit.wasm": "bf50631470eb967688cca13ee181af62"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
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
