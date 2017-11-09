package;

import haxe.ds.Vector;
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
import kha.graphics4.CompareMode;
import gltf.GLTF;
import gltf.schema.TGLTF;
import glm.GLM;
using glm.Mat4;
using glm.Quat;
using glm.Vec3;

class Sample {
    var vertexBuffer:VertexBuffer;
	var indexBuffer:IndexBuffer;
	var pipeline:PipelineState;

	var mvpID:ConstantLocation;
	var mID:ConstantLocation;

    var rotation:Quat;
	var model:Mat4;
    var vp:Mat4;
	var mvp:Mat4;

	public function new() {
        var structure = new VertexStructure();
        structure.add("position", VertexData.Float3);
        structure.add("texcoord", VertexData.Float2);
        structure.add("normal", VertexData.Float3);
        var structureLength:Int = Std.int(structure.byteSize() / 4);

		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.fragmentShader = Shaders.simple_frag;
		pipeline.vertexShader = Shaders.simple_vert;
        pipeline.cullMode = CullMode.Clockwise;
        pipeline.depthMode = CompareMode.GreaterEqual;
        pipeline.depthWrite = true;
		pipeline.compile();

		mvpID = pipeline.getConstantLocation("MVP");
		mID = pipeline.getConstantLocation("M");

		var projection = GLM.perspective(45, 4/3, 0.1, 1000, new Mat4());
        var view = GLM.lookAt(
            new Vec3(200, 200, 200),
            new Vec3(0, 75, 0),
            new Vec3(0, 1, 0),
            new Mat4()
        );
        model = new Mat4().identity();
        vp = projection * view;
        mvp = vp * model;
        rotation = new Quat().identity();

        var raw:TGLTF = GLTF.parse(Assets.blobs.Duck_gltf.toString());
        var object:GLTF = GLTF.load(raw, [Assets.blobs.Duck0_bin.bytes]);
        var positions:Vector<Float> = object.meshes[0].primitives[0].getFloatAttributeValues("POSITION");
        var normals:Vector<Float> = object.meshes[0].primitives[0].getFloatAttributeValues("NORMAL");
        var uvs:Vector<Float> = object.meshes[0].primitives[0].getFloatAttributeValues("TEXCOORD_0");
        var indices:Vector<Int> = object.meshes[0].primitives[0].getIndexValues();

        var numVerts:Int = Std.int(positions.length / 3);
		vertexBuffer = new VertexBuffer(numVerts, structure, Usage.StaticUsage);
        var vbData = vertexBuffer.lock();
        for(v in 0...numVerts) {
            // combine the separate buffers into a single buffer
            // to make life a bit easier
            vbData[(v * structureLength) + 0] = positions[(v * 3) + 0];
            vbData[(v * structureLength) + 1] = positions[(v * 3) + 1];
            vbData[(v * structureLength) + 2] = positions[(v * 3) + 2];
            vbData[(v * structureLength) + 3] =       uvs[(v * 2) + 0];
            vbData[(v * structureLength) + 4] =       uvs[(v * 2) + 1];
            vbData[(v * structureLength) + 5] =   normals[(v * 3) + 0];
            vbData[(v * structureLength) + 6] =   normals[(v * 3) + 1];
            vbData[(v * structureLength) + 7] =   normals[(v * 3) + 2];
        }
        vertexBuffer.unlock();

		indexBuffer = new IndexBuffer(indices.length, Usage.StaticUsage);
		var iData = indexBuffer.lock();
		for (i in 0...iData.length) {
			iData[i] = indices[i];
		}
		indexBuffer.unlock();
    }

    public function update():Void {
        rotation.multiplyQuats(Quat.fromEuler(0, 0.5 * Math.PI * (1/60), 0, new Quat()), rotation);
        GLM.rotate(rotation, model);
        mvp = vp * model;
    }

	public function render(frame:Framebuffer) {
		var g = frame.g4;
        g.begin();
		g.clear(Color.fromFloats(0.33, 0.33, 0.33), 0);

		g.setVertexBuffer(vertexBuffer);
		g.setIndexBuffer(indexBuffer);
		g.setPipeline(pipeline);
		g.setMatrix(mvpID, mvp);
		g.setMatrix(mID, model);
		g.drawIndexedVertices();

		g.end();
    }
}