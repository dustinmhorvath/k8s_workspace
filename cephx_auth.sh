ceph fs authorize cephfs client.readarr / r /docker/readarr rw /books rw /downloads rw
ceph fs authorize cephfs client.samba / r /storage rw /backup rw



ceph fs authorize cephfs client.prowlarr / r /containervolumes/prowlarr rw /downloads rw
ceph fs authorize cephfs client.actual / r /containervolumes/actual rw
ceph fs authorize cephfs client.sqlite / r /containervolumes rw
ceph fs authorize cephfs client.ddclient / r /containervolumes/ddclient rw
ceph fs authorize cephfs client.redbot / r /containervolumes/redbot rw
ceph fs authorize cephfs client.jellyseerr / r /containervolumes/jellyseerr rw
ceph fs authorize cephfs client.qbittorrent / r /containervolumes/qbittorrent rw /downloads rw
ceph fs authorize cephfs client.downloads / r /downloads rw
ceph fs authorize cephfs client.sonarr / r /containervolumes/sonarr rw /downloads rw /tv rw
ceph fs authorize cephfs client.radarr / r /containervolumes/radarr rw /downloads rw /movies rw
ceph fs authorize cephfs client.sabnzbd / r /containervolumes/sabnzbd rw /downloads rw
ceph fs authorize cephfs client.lidarr / r /containervolumes/lidarr rw /music rw /downloads rw /unsorted rw
ceph fs authorize cephfs client.jellyfin / r /containervolumes/jellyfin rw /tv rw /movies rw /music rw /books rw
ceph fs authorize cephfs client.satisfactory / r /containervolumes/satisfactory rw
ceph fs authorize cephfs client.homeassistant / r /containervolumes/homeassistant rw
ceph fs authorize cephfs client.zomboid / r /containervolumes/zomboid rw
ceph fs authorize cephfs client.mqtt / r /containervolumes/mqtt rw
