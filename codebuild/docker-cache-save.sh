#/bin/bash
set -e

mkdir -p $IMAGE_CACHE_ROOT
DOCKER_IMAGES_NEW=`mktemp`
docker images -a -q --no-trunc | awk -F':' '{print $2}' | sort | uniq > $DOCKER_IMAGES_NEW

DOCKER_IMAGES_CACHE=`mktemp`
find $IMAGE_CACHE_ROOT -type f -name *.tar.gz | xargs -n1 basename | awk -F. '{print $1}' | sort | uniq > $DOCKER_IMAGES_CACHE

DOCKER_IMAGES_DELETE=`mktemp`
DOCKER_IMAGES_SAVE=`mktemp`
comm -13 $DOCKER_IMAGES_NEW $DOCKER_IMAGES_CACHE > $DOCKER_IMAGES_DELETE
comm -23 $DOCKER_IMAGES_NEW $DOCKER_IMAGES_CACHE > $DOCKER_IMAGES_SAVE

if [ $(< $DOCKER_IMAGES_DELETE wc -l) -gt 0 ]; then
    echo Deleting docker images that are no longer current
    for i in `cat $DOCKER_IMAGES_DELETE`; do
      echo Deleting image $i
      rm $IMAGE_CACHE_ROOT/$i.tar.gz
    done
fi

if [ $(< $DOCKER_IMAGES_SAVE wc -l) -gt 0 ]; then
    echo Saving missing images to docker cache
    for i in `cat $DOCKER_IMAGES_SAVE`; do
      echo Saving image $i
      history=$(docker history -q $i | sed -e "s/<missing>//")
      docker save $i $history | gzip -c > $IMAGE_CACHE_ROOT/$i.tar.gz
    done
fi

rm $DOCKER_IMAGES_NEW $DOCKER_IMAGES_CACHE $DOCKER_IMAGES_DELETE $DOCKER_IMAGES_SAVE
