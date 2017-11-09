let project = new Project('glTF Sample - Kha');
project.addAssets('Assets/**');
project.addShaders('Shaders/**');
project.addSources('Sources');
project.addLibrary('glm');
project.addLibrary('gltf');
resolve(project);