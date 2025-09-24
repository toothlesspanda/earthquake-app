import { Controller } from "@hotwired/stimulus"
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import * as THREE from "three"

export default class extends Controller {
  static values = { imageUrl: String }

  connect() {
    this.setupScene();
    this.loadHeightmap();
    this.animate();
  }

  setupScene() {
    const width = 700
    const height = 700

    // Scene
    this.scene = new THREE.Scene()
    this.scene.background = new THREE.Color(0xf0f0f0)

    // Camera
    this.camera = new THREE.PerspectiveCamera(45, width / height, 1, 1000)
    this.camera.position.z = 300

    // Renderer
    this.renderer = new THREE.WebGLRenderer({ antialias: true })
    this.renderer.setSize(width, height)
    this.element.appendChild(this.renderer.domElement)

    // Light
    const ambientLight = new THREE.AmbientLight(0x404040, 0.8);
    this.scene.add(ambientLight);
    const directionalLight = new THREE.DirectionalLight(0xffffff, 1);
    directionalLight.position.set(  this.camera.position.x,
        this.camera.position.y,
        this.camera.position.z + 200 );
    this.scene.add(directionalLight);

    // Controller
    this.controls = new OrbitControls(this.camera, this.renderer.domElement);
    this.controls.enableDamping = true;
    this.controls.dampingFactor = 0.05;
  }

  loadHeightmap() {
    const loader = new THREE.TextureLoader();
    loader.load(this.imageUrlValue, (texture) => {
      const canvas = document.createElement("canvas");
      canvas.width = texture.image.width;
      canvas.height = texture.image.height;

      const ctx = canvas.getContext("2d");
      ctx.drawImage(texture.image, 0, 0);

      const data = ctx.getImageData(0, 0, canvas.width, canvas.height).data;

      const geometry = new THREE.PlaneGeometry(
          canvas.width,
          canvas.height,
          canvas.width - 1,
          canvas.height - 1
      );
      const position = geometry.attributes.position;
      const material = new THREE.MeshPhongMaterial({ wireframe: true, vertexColors: true, color: 0xffffff, });
      const colors = [];
      const color = new THREE.Color();

      const heightScaleFactor = 0.25;
      const maxIntensity = 255 * heightScaleFactor;

      // setup colors
      for (let i = 0; i < position.count; i++) {
        const r = data[i * 4];
        const height = r * heightScaleFactor;
        position.setZ(i, r * heightScaleFactor);

        const normalizedHeight = height / maxIntensity;

        if (normalizedHeight < 0.2) {
          color.setRGB(0.1, 0.4, 0.9);
        } else if (normalizedHeight < 0.6) {
          color.setRGB(0.2, 0.7, 0.2);
        } else {
          color.setRGB(0.9, 0.1, 0.1);
        }
        colors.push(color.r, color.g, color.b);
      }
      position.needsUpdate = true;

      geometry.setAttribute('color', new THREE.Float32BufferAttribute(colors, 3));
      const mesh = new THREE.Mesh(geometry, material);
      this.scene.add(mesh);

      this.renderer.render(this.scene, this.camera);
    });
  }

  animate = () => {
    requestAnimationFrame(this.animate.bind(this));
    this.controls.update();
    this.renderer.render(this.scene, this.camera);
  }
}