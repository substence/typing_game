package com.nicotroia.typinggame.view.pages
{
	import com.nicotroia.typinggame.controller.events.NavigationEvent;
	import com.nicotroia.typinggame.controller.events.NotificationEvent;
	import com.nicotroia.typinggame.model.SequenceModel;
	
	import flash.display.Bitmap;
	
	import starling.display.Button;
	import starling.events.Event;

	public class WelcomePageMediator extends PageBaseMediator
	{
		[Inject]
		public var welcomePage:WelcomePage;
		
		override protected function pageAddedToStageHandler(event:Event=null):void
		{
			super.pageAddedToStageHandler(event);
			
			//trace("welcome page addedToStage");
			
			//eventDispatcher.dispatchEvent(new NotificationEvent(NotificationEvent.CHANGE_TOP_NAV_BAR_TITLE, "What Color <i>Is</i> This?"));
			//eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.ADD_NAV_BUTTON_TO_HEADER_LEFT, null, welcomePage.settingsButton));
			
			eventMap.mapStarlingListener(welcomePage, Event.TRIGGERED, welcomePageTriggeredHandler);
		}
		
		private function welcomePageTriggeredHandler(event:Event):void
		{
			var buttonTriggered:Button = event.target as Button;
			
			trace("welcome page button triggered: " + buttonTriggered);
			
			if( buttonTriggered == welcomePage.settingsButton ) 
			{ 
				eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.NAVIGATE_TO_PAGE, SequenceModel.PAGE_Settings, null, NavigationEvent.NAVIGATE_LEFT));
			}
		}
		
		override public function onRemove():void
		{ 
			eventMap.unmapStarlingListener(welcomePage, Event.TRIGGERED, welcomePageTriggeredHandler);
			
			super.onRemove();
		}
		
	}
}