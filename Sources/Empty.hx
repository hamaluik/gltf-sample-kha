package;

import kha.Assets;
import kha.Framebuffer;
import kha.Color;
import kha.Shaders;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.Usage;
import kha.graphics4.ConstantLocation;
import kha.graphics4.CullMode;
import gltf.GLTF;
import gltf.schema.TGLTF;
import glm.GLM;
using glm.Mat4;
using glm.Vec3;

class Empty {
	var positionBuffer:VertexBuffer;
	var normalBuffer:VertexBuffer;
	var indexBuffer:IndexBuffer;
	var pipeline:PipelineState;

	var mvp:Mat4;
	var mvpID:ConstantLocation;
	var m:Mat4;
	var mID:ConstantLocation;

	public function new() {
		var posStructure = new VertexStructure();
        posStructure.add("position", VertexData.Float3);
		var normStructure = new VertexStructure();
        normStructure.add("normal", VertexData.Float3);

		pipeline = new PipelineState();
		pipeline.inputLayout = [posStructure, normStructure];
		pipeline.fragmentShader = Shaders.simple_frag;
		pipeline.vertexShader = Shaders.simple_vert;
		pipeline.compile();

		mvpID = pipeline.getConstantLocation("MVP");
		mID = pipeline.getConstantLocation("M");

        //var projection = GLM.perspective(45, 4/3, 0.01, 10, new Mat4());
        /*var view = GLM.lookAt(
            new Vec3(4, 3, 3),
            new Vec3(0, 0, 0),
            new Vec3(0, 1, 0),
            new Mat4()
        );*/
        var projection = kha.math.FastMatrix4.perspectiveProjection(45, 4/3, 0.01, 100);
        var view = kha.math.FastMatrix4.lookAt(
            new kha.math.FastVector3(4, 3, 3),
            new kha.math.FastVector3(0, 0, 0),
            new kha.math.FastVector3(0, 1, 0)
        );
		m = new Mat4().identity();
        mvp = projection * view * m;

        var raw:TGLTF = GLTF.parse(Assets.blobs.suzanne_gltf.toString());
        var object:GLTF = GLTF.load(raw, [Assets.blobs.suzanne_bin.bytes]);
        var positions:haxe.ds.Vector<Float> = object.meshes[0].primitives[0].getFloatAttributeValues("POSITION");
        var normals:haxe.ds.Vector<Float> = object.meshes[0].primitives[0].getFloatAttributeValues("NORMAL");
        var indices:haxe.ds.Vector<Int> = object.meshes[0].primitives[0].getIndexValues();

		positionBuffer = new VertexBuffer(
			Std.int(positions.length / 3),
			posStructure,
			Usage.StaticUsage
		);
		var vbData = positionBuffer.lock();
		for (i in 0...vbData.length) {
			vbData.set(i, positions[i]);
		}
		positionBuffer.unlock();

		normalBuffer = new VertexBuffer(
			Std.int(normals.length / 3),
			normStructure,
			Usage.StaticUsage
		);
		vbData = normalBuffer.lock();
		for (i in 0...vbData.length) {
			vbData.set(i, normals[i]);
		}
		normalBuffer.unlock();

		indexBuffer = new IndexBuffer(indices.length, Usage.StaticUsage);
		var iData = indexBuffer.lock();
		for (i in 0...iData.length) {
			iData[i] = indices[i];
		}
		indexBuffer.unlock();
    }

	public function render(frame:Framebuffer) {
		var g = frame.g4;
        g.begin();
		g.clear(Color.fromFloats(0.33, 0.33, 0.33));

		g.setVertexBuffers([
            positionBuffer,
            normalBuffer
        ]);
		g.setIndexBuffer(indexBuffer);
		g.setPipeline(pipeline);
		g.setMatrix(mvpID, mvp);
		g.setMatrix(mID, m);
		g.drawIndexedVertices();

		g.end();
    }
}