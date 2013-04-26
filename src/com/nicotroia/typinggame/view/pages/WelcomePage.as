package com.nicotroia.typinggame.view.pages
{
	import com.nicotroia.typinggame.model.LayoutModel;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	
	public class WelcomePage extends PageBase
	{
		public var settingsButton:Button;
		
		private var _welcomeTextImage:Image;
		private var _welcomeTextFormat:TextFormat;
		
		public function WelcomePage()
		{
			vectorPage = new WelcomePageVector();
			
			_welcomeTextFormat = new TextFormat();
			
			super();
		}
		
		private function setTextFormats(layoutModel:LayoutModel):void
		{
			_welcomeTextFormat.font = layoutModel.arialBold.fontName;
			_welcomeTextFormat.size = 42 * layoutModel.scale;
			_welcomeTextFormat.align = TextFormatAlign.CENTER;
			_welcomeTextFormat.color = 0x333333;
		}
		
		override public function reflowVectors(layoutModel:LayoutModel=null):void
		{
			setTextFormats(layoutModel);
			
			vectorPage.x = 0;
			vectorPage.y = 0;
			
			vectorPage.settingsButton.height = 88 * layoutModel.scale * Starling.contentScaleFactor;
			vectorPage.settingsButton.scaleX = vectorPage.settingsButton.scaleY;
			vectorPage.settingsButton.x = 28 * layoutModel.scale;
			vectorPage.settingsButton.y = 28 * layoutModel.scale;
			
			vectorPage.welcomeTF.width = layoutModel.appWidth;
			vectorPage.welcomeTF.height = 50 * layoutModel.scale * Starling.contentScaleFactor;
			vectorPage.welcomeTF.x = 0;
			vectorPage.welcomeTF.y = 48 * layoutModel.scale;
			vectorPage.welcomeTF.text = "Welcome";
			vectorPage.welcomeTF.setTextFormat(_welcomeTextFormat);
		}
		
		override public function drawVectors(layoutModel:LayoutModel=null):void 
		{ 
			//Remove
			removeDrawnVector( _background );
			removeDrawnVector( _welcomeTextImage );
			
			
			//Create
			_background = drawBackgroundQuad();
			settingsButton = createButtonFromMovieClip( vectorPage.settingsButton );
			_welcomeTextImage = createImageFromDisplayObject( vectorPage.welcomeTF );
			
			
			//Add
			addChildAt( _background, 0 );
			addChild(_welcomeTextImage);
			addChild(settingsButton);
		}
	}
}