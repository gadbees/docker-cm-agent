import logging
import os
import tarfile

from cmf.parcel import Repository

logging.basicConfig(level=logging.DEBUG)

parcel_cache = "/opt/cloudera/parcel-cache"
parcel_dir = "/opt/cloudera/parcels"
package_dir = "/usr/lib64/cmf/service"

## Extract parcels from cache
for parcel in os.listdir(parcel_cache):
    if parcel.endswith(".parcel"):
    	logging.info("Extracting {0}".format(parcel))
        tarfile.open(os.path.join(parcel_cache, parcel)).extractall(parcel_dir)

# Refresh creates users and sets perms
repo = Repository(parcel_dir, package_dir)
repo.ensure_users_groups_permissions = True
repo.refresh()

# Symlinks
for name, product in repo.items():
  for version, parcel in product.items():
    repo.ensure_active_symlink(parcel, activate=True)
    repo.ensure_alternatives(parcel, activate=True)
