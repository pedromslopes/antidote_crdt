%% -------------------------------------------------------------------
%%
%% Copyright <2013-2018> <
%%  Technische Universität Kaiserslautern, Germany
%%  Université Pierre et Marie Curie / Sorbonne-Université, France
%%  Universidade NOVA de Lisboa, Portugal
%%  Université catholique de Louvain (UCL), Belgique
%%  INESC TEC, Portugal
%% >
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
%% KIND, either expressed or implied.  See the License for the
%% specific language governing permissions and limitations
%% under the License.
%%
%% List of the contributors to the development of Antidote: see AUTHORS file.
%% Description and complete License: see LICENSE file.
%% -------------------------------------------------------------------

-module(prop_counter_fat).

-define(PROPER_NO_TRANS, true).
-include_lib("proper/include/proper.hrl").

%% API
-export([prop_counter_fat_spec/0, op/0, spec/1]).


prop_counter_fat_spec() ->
 crdt_properties:crdt_satisfies_spec(antidote_crdt_counter_fat, fun op/0, fun spec/1).


spec(Operations1) ->
  Operations = crdt_properties:filter_resets(Operations1),
  lists:sum([X || {_, {increment, X}} <- Operations])
    - lists:sum([X || {_, {decrement, X}} <- Operations]).

% generates a random counter operation
op() ->
  oneof([
    {increment, integer()},
    {decrement, integer()},
    {reset, {}}
  ]).

