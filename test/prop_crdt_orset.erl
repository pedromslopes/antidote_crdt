%% -------------------------------------------------------------------
%%
%% Copyright (c) 2014 SyncFree Consortium.  All Rights Reserved.
%%
%% This file is provided to you under the Apache License,
%% Version 2.0 (the "License"); you may not use this file
%% except in compliance with the License.  You may obtain
%% a copy of the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing,
%% software distributed under the License is distributed on an
%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%% KIND, either express or implied.  See the License for the
%% specific language governing permissions and limitations
%% under the License.
%%
%% -------------------------------------------------------------------

-module(prop_crdt_orset).

-define(PROPER_NO_TRANS, true).
-include_lib("proper/include/proper.hrl").

%% API
-export([prop_orset_spec/0]).


prop_orset_spec() ->
 crdt_properties:crdt_satisfies_spec(antidote_crdt_orset, fun set_op/0, fun add_wins_set_spec/1).


add_wins_set_spec(Operations1) ->
  Operations = lists:flatmap(fun normalizeOperation/1, Operations1),
  lists:usort(
    % all X,
    [X ||
      % such that there is an add operation for X
      {AddClock, {add, X}} <- Operations,
      % and there is no remove operation after the add
      [] == [Y || {RemoveClock, {remove, Y}} <- Operations, X == Y, crdt_properties:clock_le(AddClock, RemoveClock)]
    ]).

% transforms add_all and remove_all into single operations
normalizeOperation({Clock, {add_all, Elems}}) ->
  [{Clock, {add, Elem}} || Elem <- Elems];
normalizeOperation({Clock, {remove_all, Elems}}) ->
  [{Clock, {remove, Elem}} || Elem <- Elems];
normalizeOperation(X) ->
  [X].

% generates a random counter operation
set_op() ->
  oneof([
    {add, set_element()},
    {add_all, list(set_element())},
    {remove, set_element()},
    {remove_all, list(set_element())}
  ]).

set_element() ->
  oneof([a,b]).

