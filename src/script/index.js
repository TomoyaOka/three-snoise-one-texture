import Stage from "./modules/stage.js";
import Model from "./modules/mesh.js";


let stage,mesh;

function rendering() {
  stage = new Stage();
  mesh = new Model(stage);

  stage._init();
  mesh._init();

  window.addEventListener("resize", ()=>{
    stage.onResize();
    mesh.onResize();
  });

  const loop = (time) => {
    requestAnimationFrame(loop);
    stage.onLoop();
    mesh.onLoop();
  };
  loop();
}

window.addEventListener("DOMContentLoaded",rendering);

export {};


