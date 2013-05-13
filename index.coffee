THREE = require 'three'
requestAnimationFrame = require 'raf'

View = require './lib/view.coffee'
Control = require './lib/control/control.coffee'

scene = new THREE.Scene()
view = new View(THREE)
view.bindToScene(scene)

camera = view.camera

view.appendTo document.body
controls = new Control(document.body)

pointLight = new THREE.PointLight(0xFFFFFF)

# set its position
pointLight.position.x = 10
pointLight.position.y = 100
pointLight.position.z = 20

# add to the scene
scene.add pointLight

ambientLight = new THREE.AmbientLight(0x222222)
scene.add ambientLight

camera.position.z = 300

radius = 50
segments = 16
rings = 16

geometry = new THREE.SphereGeometry(
    radius,
    segments,
    rings)

sphereMaterial = new THREE.MeshLambertMaterial color: 0xCC0000

sphere = new THREE.Mesh geometry, sphereMaterial

scene.add sphere


view.render scene

requestAnimationFrame(window).on 'data', (dt) =>
  view.render(scene)
