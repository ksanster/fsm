package com.tengu.fsm.impl
{
	import com.tengu.fsm.api.IFSM;
	import com.tengu.fsm.api.IState;
	import com.tengu.log.LogFactory;
	import com.tengu.log.Logger;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	public class StateManager extends EventDispatcher implements IFSM
	{
		
		private var transitionTable:Object 	= null;
		private var statesClasses:Object  	= null;
		private var states:Object 			= null;

		private var currentId:String = null;
		
		public final function get currentStateId():String
		{
			return currentId;
		}
		
		public final function get currentState():IState 
		{
			return states[currentId];
		}

		public function StateManager()
		{
			super();
			initialize();
		}
		
		private function initialize():void
		{
			states 			= {};
			statesClasses	= {};
			transitionTable = {};
		}
		
		
		private function getTransitionList(stateId:String):Dictionary
		{
			var result:Dictionary = transitionTable[stateId];
			if (result == null)
			{
				result = new Dictionary();
				transitionTable[stateId] = result;
			}
			return result;
		}

		private function getState (stateId:String):IState
		{
			var stateClass:Class = statesClasses[stateId];
			var result:IState 	 = states[stateId];
			
			if (result == null)
			{
				if (stateClass != null)
				{
					result = new stateClass() as IState;
					result.manager = this;
					states[stateId] = result;
				}
			}
			return result;
		}
		
		public function registerState(id:String, stateClass:Class/*<IStateInfo>*/):void
		{
			if (statesClasses[id] != null)
			{
				throw new ArgumentError("State with id <" + id + "> already registered");
			}
			
			statesClasses[id] = stateClass;
		}
		
		public function addTransition(input:*, to:String, from:Vector.<String>):void
		{
			var stateInfo:IState;
			var transitions:Dictionary = null;
			
			for each (var stateId:String in from)
			{
				transitions = getTransitionList(stateId);
				transitions[input] = to;
			}
		}
		
		public function setState(id:String):void
		{
			var currentState:IState = states[currentId];
			var newState:IState = getState(id);
			if (newState == null)
			{
				LogFactory.getLogger(this).error("State with id <" + id + "> not registered");
				return;
			}
			
			if (currentState != null)
			{
				currentState.onExit();
			}
			currentId = id;
			currentState = states[id];
			currentState.onEnter();
		}
		
		public function handle(input:*):void
		{
			var transitions:Dictionary = getTransitionList(currentId);
			var newStateId:String = transitions[input];
			setState(newStateId);
		}
	}
}