assets = {}

assets.finger = love.graphics.newImage("assets/finger.png")
assets.particle = love.graphics.newImage("assets/particle.png")
assets.title = love.graphics.newImage("assets/titleScreenStart.png")

assets.level2 = {}
assets.level2.anim_2_1 = love.graphics.newImage("assets/titleScreen1.png")
assets.level2.anim_2_2 = love.graphics.newImage("assets/titleScreen2.png")
assets.level2.credit_card = love.graphics.newImage("assets/credt-card.png")
assets.level2.fifty_cents = love.graphics.newImage("assets/fifty-cents.png")
assets.level2.one_euro = love.graphics.newImage("assets/one-euro.png")
assets.level2.phone = love.graphics.newImage("assets/phone.png")
assets.level2.scissors = love.graphics.newImage("assets/scissors.png")
assets.level2.two_euros = love.graphics.newImage("assets/two-euros.png")
assets.level2.wallet = love.graphics.newImage("assets/wallet.png")

assets.fonts = {}
assets.fonts.fontMedium = love.graphics.newFont("assets/OpenSans-Regular.ttf", 56)

assets.music = {}
assets.music.level2 = love.audio.newSource("assets/DuoTeslar_UniversalFunk.mp3", "stream")
assets.music.level2:setLooping(true)
assets.music.title = love.audio.newSource("assets/pornophonique_-_sad_robot.mp3", "stream")
assets.music.title:setLooping(true)

assets.sounds = {}
assets.sounds.friction = {}
assets.sounds.friction[1] = love.audio.newSource("assets/sound_friction_1.mp3", "static")
assets.sounds.friction[2] = love.audio.newSource("assets/sound_friction_3.mp3", "static")
assets.sounds.crowd = love.audio.newSource("assets/102410__jakobthiesen__crowd-waiting-to-board-toronto-island-ferry.mp3", "stream")
assets.sounds.crowd:setVolume(0.4)
assets.sounds.dundundun = love.audio.newSource('assets/45654__simon-lacelle__dun-dun-dun.mp3', "static")