#!/bin/sh
set -e

if [ -z "$(ls -A /var/www/html/)" ]; then
  
fi

remove_package()
{
    PACKAGE_NAME=$1

    apk del --purge "$PACKAGE_NAME" # Uninstall the package
    apk del $(apk info -d "$PACKAGE_NAME" 2>/dev/null) # Clean up orphaned dependencies
    rm -rf /var/cache/apk/* # Clear APK cache
}
