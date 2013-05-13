class View
  THREE: null,
  temporaryPosition: null,
  temporaryVector: null,
  fov: null,
  width: null,
  height: null,
  aspectRatio: null,
  nearPlane: null,
  farPlane: null,
  skyColor: null,
  ortho: null,
  camera: null,
  element: null,
  renderer: null,
  constructor: (three, opts={})->
    @THREE = three # three.js doesn't support multiple instances on a single page
    @fov = opts.fov or 60
    @width = opts.width or 1024
    @height = opts.height or 512
    @aspectRatio = opts.aspectRatio or @width / @height
    @nearPlane = opts.nearPlane or 1
    @farPlane = opts.farPlane or 10000
    @skyColor = opts.skyColor or 0x000000
    @ortho = opts.ortho
    @temporaryPosition = new @THREE.Vector3(0, 0, 0)
    @temporaryVector = new @THREE.Vector3(0, 0, 1)
    if @ortho
      @camera = new @THREE.OrthographicCamera(@width / -2, @width / 2, @height / 2, @height / -2, @nearPlane, @farPlane)
    else
      @camera = new @THREE.PerspectiveCamera(@fov, @aspectRatio, @nearPlane, @farPlane)
    @camera.lookAt new @THREE.Vector3(0, 0, 0)
    return @ unless process.browser
    @createRenderer()
    @element = @renderer.domElement

  createRenderer: ->
    @renderer = new @THREE.WebGLRenderer(antialias: true)
    @renderer.setSize @width, @height
    @renderer.setClearColorHex @skyColor, 1.0
    @renderer.clear()

  bindToScene: (scene) ->
    scene.add @camera

  cameraPosition: ->
    temporaryPosition.multiplyScalar 0
    temporaryPosition.applyMatrix4 @camera.matrixWorld
    [temporaryPosition.x, temporaryPosition.y, temporaryPosition.z]

  cameraVector: ->
    temporaryVector.multiplyScalar 0
    temporaryVector.z = -1
    @camera.matrixWorld.rotateAxis temporaryVector
    [temporaryVector.x, temporaryVector.y, temporaryVector.z]

  resizeWindow: (width, height) ->
    if @element.parentElement
      width = width or @element.parentElement.clientWidth
      height = height or @element.parentElement.clientHeight
    @camera.aspect = @aspectRatio = width / height
    @width = width
    @height = height
    @camera.updateProjectionMatrix()
    @renderer.setSize width, height

  render: (scene) ->
    @renderer.render scene, @camera

  appendTo: (element) ->
    if typeof element is "object"
      element.appendChild @element
    else
      document.querySelector(element).appendChild @element
    @resizeWindow @width, @height

module.exports = View
