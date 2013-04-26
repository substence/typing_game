package com.nicotroia.typinggame.controller.commands
{
	import com.nicotroia.typinggame.controller.events.LayoutEvent;
	import com.nicotroia.typinggame.model.LayoutModel;
	
	import flash.display.Screen;
	import flash.events.StageOrientationEvent;
	import flash.system.Capabilities;
	
	import org.robotlegs.mvcs.StarlingCommand;
	
	import starling.core.Starling;

	public class LayoutAppCommand extends StarlingCommand
	{
		[Inject]
		public var event:LayoutEvent;
		
		[Inject]
		public var layoutModel:LayoutModel;
		
		override public function execute():void
		{
			trace("LayoutAppCommand via " + event.type);
			
			//trace(contextView.stage.stageWidth, Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.fullScreenWidth);
			
			if( event.type == LayoutEvent.RESIZE ) { 
				
			}
			else if( event.type == LayoutEvent.ORIENTATION_CHANGE ) { 
				
			}
			
			if( Capabilities.version.substr(0,3).toUpperCase() == "AND" ) { 
				layoutModel.changeAppLayout(Starling.current.nativeStage.orientation, Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight);
			}
			else { 
				layoutModel.changeAppLayout(Starling.current.nativeStage.orientation, Starling.current.nativeStage.fullScreenWidth, Starling.current.nativeStage.fullScreenHeight);
			}
		}
	}
}