## docker-cm-agent

This is an attempt to run Cloudera Manager Agent in docker on marathon. The idea is that we can run some number of cm-agents ( each with a configured AGENT_UUID ), and delegate most of its management to Cloudera Manager.

For example, if a mesos-slave goes down and marathon brings up one of the cm-agents on another machine, though it starts with basically a blank image, cloudera manager will copy parcels to it and (maybe?) start services for it as well. We maintain persistence of any CM associations by maintaining a consistent AGENT_UUID.

For most services, this is really only beneficial if we have some service discovery as well. That's why this container runs with HOST networking. CM manages what ports services use, and so by using HOST networking and Mesos-DNS, this might just work.
   
YMMV   
