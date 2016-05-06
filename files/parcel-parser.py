#!/usr/bin/env python

import json, os, pwd, grp
from urllib import urlretrieve

def alt_setup(location):


	file = open("{0}/meta/alternatives.json".format(location), "r")
	data = json.load(file)


	for key in data.keys():

		if data[key]['isDirectory']:
			if not os.path.isdir(str(data[key]['destination'])):
				os.system("mkdir -p {0}".format(data[key]['destination']))
		else:
			dest = str(data[key]['destination']).split('/')
			dest.pop()
			dest = "/" + str('/'.join(dest))
			if not os.path.isdir(dest):
				os.system("mkdir -p {0}".format(dest))


		os.system("alternatives --install {0} {1} {2}{3} {4}".format(data[key]['destination'], key, location, data[key]['source'], data[key]['priority']))

	file.close()

def perms_setup(location):

	file = open("{0}/meta/permissions.json".format(location), "r")
	data = json.load(file)

	for key in data.keys():

		try: 
			pwd.getpwnam(data[key]['user'])
		except KeyError:
			os.system("useradd {0}".format(data[key]['user']))
		
		try:
			grp.getgrnam(data[key]['group'])
		except KeyError:
			os.system("groupadd {0}".format(data[key]['group']))
		
		os.system("chown {0}:{1} {2}{3}".format(data[key]['user'], data[key]['group'], location, key))
		os.system("chmod {0} {1}{2}".format(data[key]['permissions'], location, key))	

	file.close()


#### Configuration options START
cdh_parcel_name = "CDH-5.7.0-1.cdh5.7.0.p0.45"
cdh_parcel_repo_url = "https://archive.cloudera.com/cdh5/parcels/5.7.0/"
cdh_parcel_location = "/opt/cloudera/parcels/{0}/".format(cdh_parcel_name)
centos_version = "el6"
anaconda_version = "2.5.0"
anaconda_parcel_repo_url = "https://repo.continuum.io/pkgs/misc/parcels/archive/"
anaconda_parcel_location = "/opt/cloudera/parcels/Anaconda-{0}-{1}.parcel".format(anaconda_version, centos_version)
#### Configuration options END

os.system("mkdir -p /opt/cloudera/parcels/")
urlretrieve("{0}{1}-{2}.parcel".format(cdh_parcel_repo_url, cdh_parcel_name, centos_version), "/opt/cloudera/parcels/{0}-{1}.parcel".format(cdh_parcel_name, centos_version))
urlretrieve("{0}Anaconda-{1}-{2}.parcel".format(anaconda_parcel_repo_url, anaconda_version, centos_version), "/opt/cloudera/parcels/Anaconda-{0}-{1}.parcel".format(anaconda_version, centos_version))
os.system("tar -xzf /opt/cloudera/parcels/{0}-{1}.parcel -C /opt/cloudera/parcels/".format(cdh_parcel_name, centos_version))
os.system("tar -xzf /opt/cloudera/parcels/Anaconda-{0}-{1}.parcel -C /opt/cloudera/parcels/".format(anaconda_version, centos_version))

alt_setup(cdh_parcel_location)
perms_setup(cdh_parcel_location)

os.system("ln -s {0} /opt/cloudera/parcels/CDH".format(cdh_parcel_location))

os.system("rm -f {0}-{1}.parcel".format(cdh_parcel_location, centos_version))