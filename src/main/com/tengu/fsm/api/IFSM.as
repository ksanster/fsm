package com.tengu.fsm.api
{
	public interface IFSM
	{
		function get currentStateId ():String;

		/**
		 * Add new state to set of states
		 * @param id State identifier
		 * @param stateClass Class with Info about state
		 * 
		 */		
		function registerState (id:String, stateClass:Class/*<IStateInfo>*/):void;
		
		/**
		 * Add new transition to table of transition
		 * @param input  Input signal (or set of signals) which leads to change state
		 * @param to state  Id of state to change
		 * @param from List of states, from which change is allowed
		 * 
		 */		
		function addTransition (input:*, to:String, from:Vector.<String>):void;
		
		/**
		 * Directly change state
		 * @param id New state id
		 * 
		 */
		function setState (id:String):void;
		
		/**
		 * Handle input signals 
		 * @param inputs Set of input signals
		 * 
		 */
		function handle (input:*):void;
	}
}