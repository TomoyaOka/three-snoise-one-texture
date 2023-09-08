import { ShaderMaterial,PlaneGeometry,Mesh ,TextureLoader,Vector2} from "three";
import vertexShader from "../shader/vertex.glsl?raw";
import fragmentShader from "../shader/fragment.glsl?raw";

import { gsap,Power4 } from "gsap";


export default class Model {
  constructor(stage) {
    this.stage = stage;
    this.geometry;
    this.material;
    this.mesh;
    this.loader = new TextureLoader();

    this.mouse = new Vector2(0.0,0.0);

    this.width = window.innerWidth;
    this.height = window.innerHeight;

  }

  _init() {
    this.createMesh();
  }

  createMesh() {
    const size = {
      x:2,
      y:2,
    }

    const texture = this.loader.load("./img.jpeg");

    this.disp = this.loader.load("./noise02.jpg");
    const uniforms = {
      uResolution: {
        value: new Vector2(this.width,this.height),
      },
      uImageResolution: {
        value: new Vector2(2048, 1356),
      },
      uTexture: {
        value: texture,
      },
      disp: { 
        value: this.disp //noise-map
      },
      uTime:{
        value:0.0
      },
    }
    
    this.geometry = new PlaneGeometry(size.x,size.y,100,100);
    this.material = new ShaderMaterial({
      uniforms:uniforms,
      vertexShader: vertexShader,
      fragmentShader:fragmentShader
    });
    this.mesh = new Mesh(this.geometry,this.material);
    this.stage.scene.add(this.mesh);


  }

  onLoop() {
    this.mesh.material.uniforms.uTime.value += 0.1;
  }

  onResize() {
    this.width = window.innerWidth;
    this.height = window.innerHeight;

    this.mesh.material.uniforms.uResolution.value.set(this.width,this.height);
  }
}