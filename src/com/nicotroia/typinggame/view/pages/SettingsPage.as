package com.nicotroia.typinggame.view.pages
{
	import com.nicotroia.typinggame.model.LayoutModel;
	
	import flash.text.TextFormat;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;

	public class SettingsPage extends PageBase
	{
		public var acceptButton:Button;
		public var cancelButton:Button;
		
		public function SettingsPage()
		{
			vectorPage = new SettingsPageVector();
			
			super();
		}
		
		override public function reflowVectors(layoutModel:LayoutModel=null):void
		{
			vectorPage.x = 0;
			vectorPage.y = 0;
			
			vectorPage.acceptButton.height = 88 * layoutModel.scale * Starling.contentScaleFactor;
			vectorPage.acceptButton.scaleX = vectorPage.acceptButton.scaleY;
			vectorPage.acceptButton.x = layoutModel.appWidth - (vectorPage.acceptButton.width/Starling.contentScaleFactor) - (28 * layoutModel.scale);
			vectorPage.acceptButton.y = layoutModel.appHeight - (vectorPage.acceptButton.height/Starling.contentScaleFactor) - (100 * layoutModel.scale);
			
			vectorPage.cancelButton.height = 88 * layoutModel.scale * Starling.contentScaleFactor;
			vectorPage.cancelButton.scaleX = vectorPage.acceptButton.scaleY;
			vectorPage.cancelButton.x = 28 * layoutModel.scale;
			vectorPage.cancelButton.y = layoutModel.appHeight - (vectorPage.cancelButton.height/Starling.contentScaleFactor) - (100 * layoutModel.scale);
		}
		
		override public function drawVectors(layoutModel:LayoutModel=null):void 
		{ 
			//remove
			removeDrawnVector( _background );
			removeDrawnVector( acceptButton );
			removeDrawnVector( cancelButton );
			
			
			//create
			_background = drawBackgroundQuad();
			acceptButton = createButtonFromMovieClip( vectorPage.acceptButton );
			cancelButton = createButtonFromMovieClip( vectorPage.cancelButton );
			
			
			//add
			addChildAt( _background, 0 );
			addChild( acceptButton );
			addChild( cancelButton );
		}
	}
}