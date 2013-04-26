package com.nicotroia.typinggame
{
	import starling.display.Sprite;
	import starling.events.Event;

	public class Application extends Sprite
	{
		private var _context:GameContext;
		
		public function Application()
		{
			super();
			
			_context = new GameContext(this);
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(event:Event):void
		{
			trace("Application added to stage");
		}
	}
}