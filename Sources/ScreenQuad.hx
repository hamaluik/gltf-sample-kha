import kha.Color;
import kha.Shaders;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.Usage;
import kha.graphics4.CullMode;
import kha.graphics4.TextureUnit;
import kha.graphics4.Graphics;
import kha.Image;

class ScreenQuad {
	var pipeline:PipelineState;

    var vertexBuffer:VertexBuffer;
	var indexBuffer:IndexBuffer;

    var texID:TextureUnit;

    public function new() {
        var structure = new VertexStructure();
        structure.add("position", VertexData.Float2);
        structure.add("texcoord", VertexData.Float2);

		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = Shaders.screenquad_vert;
		pipeline.fragmentShader = Shaders.screenquad_frag;
        pipeline.cullMode = CullMode.None;
        pipeline.depthWrite = true;

        try {
            pipeline.compile();
        }
        catch(e:Dynamic) {
            js.Browser.console.error(e);
        }

        texID = pipeline.getTextureUnit("albedoTex");

        var vertices:Array<Float> = [
            -1, -1,  0, 0,
             1, -1,  1, 0,
             1,  1,  1, 1,
            -1,  1,  0, 1,
        ];
        var indices:Array<Int> = [
            0, 1, 2,
            2, 3, 0
        ];

        vertexBuffer = new VertexBuffer(4, structure, Usage.StaticUsage);
        var vData = vertexBuffer.lock();
        for(i in 0...vData.length) {
            vData[i] = vertices[i];
        }
        vertexBuffer.unlock();

		indexBuffer = new IndexBuffer(6, Usage.StaticUsage);
		var iData = indexBuffer.lock();
		for (i in 0...iData.length) {
			iData[i] = indices[i];
		}
		indexBuffer.unlock();
    }

    public function render(g:Graphics, image:Image) {
        g.begin();
        //g.clear(Color.fromFloats(0.33, 0.33, 0.33), 1);
		g.setVertexBuffer(vertexBuffer);
		g.setIndexBuffer(indexBuffer);
		g.setPipeline(pipeline);
        g.setTexture(texID, image);
		g.drawIndexedVertices();
    }
}