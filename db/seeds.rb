# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# includes image url and (optional) image tag(s)
images = [['https://photos.smugmug.com/France-and-a-little-bit-of-Spain-Fall-2017/i-zw9dMPr/0/641ccef9/X3/DSC04307-X3.jpg',
           '#MontSaintMichel', '#LowTide'],
          ['https://photos.smugmug.com/France-and-a-little-bit-of-Spain-Fall-2017/i-XzpWBxs/0/e84e259b/X2/DSC04248-X2.jpg',
           '#AdorableNarrowStreet'],
          ['https://photos.smugmug.com/France-and-a-little-bit-of-Spain-Fall-2017/i-DXJHR3b/0/ace7af9c/X3/DSC04271-X3.jpg',
           '#StMalo'],
          ['https://photos.smugmug.com/France-and-a-little-bit-of-Spain-Fall-2017/i-FJ2xN7x/0/ffab00f9/X3/DSC04286-X3.jpg',
           '#StMalo', '#LowTide'],
          ['https://photos.smugmug.com/France-and-a-little-bit-of-Spain-Fall-2017/i-GsxgV6X/0/98070816/X3/DSC04292-X3.jpg',
           '#MontSaintMichel', '#LowTide'],
          ['https://photos.smugmug.com/France-and-a-little-bit-of-Spain-Fall-2017/i-LXPtHL7/0/60e80200/X3/DSC04363-X3.jpg',
           '#StupidRubocop'],
          ['https://photos.smugmug.com/France-and-a-little-bit-of-Spain-Fall-2017/i-7KTj9R9/0/69cc4be0/X3/DSC04398-X3.jpg',
           '#JoshuaTreeInFrance'],
          ['https://photos.smugmug.com/France-and-a-little-bit-of-Spain-Fall-2017/i-JLJ2Vnw/0/dae22b37/X3/DSC04399-X3.jpg',
           '#JoshuaTreeInFrance'],
          ['https://photos.smugmug.com/France-and-a-little-bit-of-Spain-Fall-2017/i-LkfRbjc/0/0989c529/X2/DSC04407-X2.jpg',
           '#Nantes'],
          ['https://photos.smugmug.com/France-and-a-little-bit-of-Spain-Fall-2017/i-m7W9mK8/0/cb549c0e/X3/DSC04411-X3.jpg',
           '#Nantes', '#StreetArt'],
          ['https://photos.smugmug.com/France-and-a-little-bit-of-Spain-Fall-2017/i-v864vRK/0/62457c32/X3/DSC04419-X3.jpg',
           '#Nantes', '#FunkZoneInFrance'],
          ['https://photos.smugmug.com/France-and-a-little-bit-of-Spain-Fall-2017/i-Gpm5c3m/0/285d33d3/X3/DSC04445-X3.jpg',
           '#Nantes', '#JulesVerne'],
          ['https://photos.smugmug.com/France-and-a-little-bit-of-Spain-Fall-2017/i-hsP9MTm/0/a23e09d9/X3/DSC04468-X3.jpg',
           '#Nantes'],
          ['https://photos.smugmug.com/France-and-a-little-bit-of-Spain-Fall-2017/i-mKNKsS9/0/488e5961/X3/DSC04472-X3.jpg',
           '#Nantes', '#Surreal'],
          ['https://photos.smugmug.com/France-and-a-little-bit-of-Spain-Fall-2017/i-xsdcsXW/0/39c700fa/X3/DSC04479-X3.jpg',
           '#StupidRubocop'],
          ['https://photos.smugmug.com/France-and-a-little-bit-of-Spain-Fall-2017/i-sLHfLXs/0/70080664/X3/DSC04491-X3.jpg',
           '#Carnival'],
          ['https://photos.smugmug.com/France-and-a-little-bit-of-Spain-Fall-2017/i-LQDJ5Jt/0/9cef0ad0/X3/DSC04505-X3.jpg',
           '#Chateau'],
          ['https://photos.smugmug.com/France-and-a-little-bit-of-Spain-Fall-2017/i-xNF6bLk/0/d150e33f/X3/DSC04552-X3.jpg',
           '#Chateau'],
          ['https://photos.smugmug.com/France-and-a-little-bit-of-Spain-Fall-2017/i-wM8RkJt/0/291daee8/X3/DSC04564-X3.jpg',
           '#Paris'],
          ['https://photos.smugmug.com/France-and-a-little-bit-of-Spain-Fall-2017/i-2c2tHzW/0/07e87852/X3/DSC04652-X3.jpg',
           '#Paris'],
          ['https://www.factzoo.com/sites/all/img/montage/large-light-wombat.jpg']]

images.each do |info|
  img = Image.new(image_url: info[0])
  i = 1
  while info[i].present?
    img.tag_list.add(info[i])
    i += 1
  end
  img.save!
end
