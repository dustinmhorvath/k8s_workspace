ceph fs authorize cephfs client.transmission / r /docker/transmission rw /downloads rw
ceph fs authorize cephfs client.deluge / r /docker/deluge rw /downloads rw
ceph fs authorize cephfs client.qbittorrent / r /docker/qbittorrent rw /downloads rw
ceph fs authorize cephfs client.jackett / r /docker/jackett rw
ceph fs authorize cephfs client.jellyfin / r /docker/jellyfin rw /tv rw /movies rw /music rw /books rw
ceph fs authorize cephfs client.sonarr / r /docker/sonarr rw /tv rw /downloads rw
ceph fs authorize cephfs client.radarr / r /docker/radarr rw /movies rw /downloads rw
ceph fs authorize cephfs client.lidarr / r /docker/lidarr rw /music rw /downloads rw /unsorted rw
ceph fs authorize cephfs client.readarr / r /docker/readarr rw /books rw /downloads rw
ceph fs authorize cephfs client.prowlarr / r /docker/prowlarr rw
ceph fs authorize cephfs client.redbot / r /docker/redbot rw
ceph fs authorize cephfs client.samba / r /storage rw /backup rw

ceph fs authorize cephfs client.docker / r /docker rw

