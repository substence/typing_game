package com.nicotroia.typinggame
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Stage;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	
	public class Assets
	{
		public static var roundedScaleFactor:Number = 1;
		
		//[Embed(source="/Users/nicotroia/PROJECTS/what_color_is_this/src/assets/graphics/atlas.png")]
		//public static const AtlasTexture:Class;
		
		//[Embed(source="/Users/nicotroia/PROJECTS/what_color_is_this/src/assets/graphics/atlas.xml", mimeType="application/octet-stream")]
		//public static const AtlasXML:Class;
		
		private static var _atlas:TextureAtlas;
		private static var _textures:Dictionary = new Dictionary();
		
		public static function getTexture(name:String):Texture
		{
			if( _textures[name] == undefined ) { 
				var bitmap:Bitmap = new Assets[name]();
				_textures[name] = Texture.fromBitmap(bitmap, true, false, Starling.contentScaleFactor);
			}
			
			return _textures[name];
		}
		
		public static function getAtlas():TextureAtlas
		{
			if( _atlas == null ) { 
				var texture:Texture = getTexture("AtlasTexture");
				//var xml:XML = XML(new AtlasXML());
				
				//_atlas = new TextureAtlas(texture, xml);
			}
			
			return _atlas;
		}
		
		public static function starlingDisplayObjectToBitmap(disp:DisplayObject, scl:Number=1.0):BitmapData
		{
			var rc:Rectangle = new Rectangle();
			disp.getBounds(disp, rc);
			
			var stage:Stage = Starling.current.stage;
			var rs:RenderSupport = new RenderSupport();
			
			rs.clear();
			rs.scaleMatrix(scl, scl);
			rs.setOrthographicProjection(0, 0, stage.stageWidth, stage.stageHeight);
			rs.translateMatrix(-rc.x, -rc.y); // move to 0,0
			disp.render(rs, 1.0);
			rs.finishQuadBatch();
			
			var outBmp:BitmapData = new BitmapData(rc.width*scl, rc.height*scl, true);
			Starling.context.drawToBitmapData(outBmp);
			
			return outBmp;
		}
	}
}