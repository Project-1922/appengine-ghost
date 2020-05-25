FROM ghost:3.0.3-alpine as cloudinary
WORKDIR $GHOST_INSTALL/current
ADD subscribe-form.hbs $GHOST_INSTALL/current/content/themes/casper/partials/subscribe-form.hbs
RUN chown node:node $GHOST_INSTALL/current/content/themes/casper/partials/subscribe-form.hbs  
ADD default.hbs $GHOST_INSTALL/current/content/themes/casper/default.hbs
RUN chown node:node $GHOST_INSTALL/current/content/themes/casper/default.hbs  
ADD site-nav.hbs $GHOST_INSTALL/current/content/themes/casper/partials/site-nav.hbs
RUN chown node:node $GHOST_INSTALL/current/content/themes/casper/partials/site-nav.hbs 
ADD screen.css   $GHOST_INSTALL/current/content/themes/casper/assets/built/screen.css 
RUN chown node:node $GHOST_INSTALL/current/content/themes/casper/assets/built/screen.css 
ADD screen.css   $GHOST_INSTALL/current/content/themes/casper/assets/built/screen.css.map
RUN chown node:node $GHOST_INSTALL/current/content/themes/casper/assets/built/screen.css.map 
RUN su-exec node yarn add ghost-storage-cloudinary@2
 
FROM ghost:3.0.3-alpine
COPY --chown=node:node --from=cloudinary $GHOST_INSTALL/current/node_modules $GHOST_INSTALL/current/node_modules
COPY --chown=node:node --from=cloudinary $GHOST_INSTALL/current/node_modules/ghost-storage-cloudinary $GHOST_INSTALL/current/core/server/adapters/storage/ghostStorageCloudinary
COPY --chown=node:node --from=cloudinary $GHOST_INSTALL/current/content/themes/casper/partials/subscribe-form.hbs $GHOST_INSTALL/current/content/themes/casper/partials/subscribe-form.hbs
COPY --chown=node:node --from=cloudinary $GHOST_INSTALL/current/content/themes/casper/default.hbs $GHOST_INSTALL/current/content/themes/casper/default.hbs
COPY --chown=node:node --from=cloudinary $GHOST_INSTALL/current/content/themes/casper/partials/site-nav.hbs $GHOST_INSTALL/current/content/themes/casper/partials/site-nav.hbs
COPY --chown=node:node --from=cloudinary $GHOST_INSTALL/current/content/themes/casper/assets/built/screen.css  $GHOST_INSTALL/current/content/themes/casper/assets/built/screen.css
COPY --chown=node:node --from=cloudinary $GHOST_INSTALL/current/content/themes/casper/assets/built/screen.css.map  $GHOST_INSTALL/current/content/themes/casper/assets/built/screen.css.map


RUN set -ex; \
    su-exec node ghost config storage.active ghost-storage-cloudinary; \
    su-exec node ghost config storage.ghostStorageCloudinary.upload.use_filename false; \
    su-exec node ghost config storage.ghostStorageCloudinary.upload.unique_filename true; \
    su-exec node ghost config storage.ghostStorageCloudinary.upload.overwrite false; \
    su-exec node ghost config storage.ghostStorageCloudinary.fetch.quality auto; \
    su-exec node ghost config storage.ghostStorageCloudinary.fetch.secure true; 