#This file is part of FlightGear.
#
#FlightGear is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 2 of the License, or
#(at your option) any later version.
#
#FlightGear is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with FlightGear.  If not, see <http://www.gnu.org/licenses/>.

# This is the main addon Nasal hook. It MUST contain a function
# called "main". The main function will be called upon init with
# the addons.Addon instance corresponding to the addon being loaded.
#
# This script will live in its own Nasal namespace that gets
# dynamically created from the global addon init script.
# It will be something like "__addon[ADDON_ID]__" where ADDON_ID is
# the addon identifier, such as "org.flightgear.addons.Skeleton".
#
# See $FG_ROOT/Docs/README.add-ons for info about the addons.Addon
# object that is passed to main(), and much more. The latest version
# of this README.add-ons document is at:
#
#   https://sourceforge.net/p/flightgear/fgdata/ci/next/tree/Docs/README.add-ons
#

# Positions

var rmPos =
{
	lA_x: 0,
	lA_y: 0,
	lA_z: 0,
	lAO_x: 0,
	lH_x: 0,
	lH_y: 0,
	lH_z: 0,
	rA_x: 0,
	lA_y: 0,
	rA_z: 0,
	rAO_x: 0,
	rH_x: 0,
	rH_y: 0,
	rH_z: 0,
	new: func(lA_x, lA_y, lA_z, lAO_x, lH_x, lH_y, lH_z, rA_x, rA_y, rA_z, rAO_x, rH_x, rH_y, rH_z)
	{
		var m = { parents: [rmPos] };
		m.lA_x = lA_x;
		m.lA_y = lA_y;
		m.lA_z = lA_z;
		m.lAO_x = lAO_x;
		m.lH_x = lH_x;
		m.lH_y = lH_y;
		m.lH_z = lH_z;
		m.rA_x = rA_x;
		m.rA_y = rA_y;
		m.rA_z = rA_z;
		m.rAO_x = rAO_x;
		m.rH_x = rH_x;
		m.rH_y = rH_y;
		m.rH_z = rH_z;
		return m;
	}
};

var pos =
{
    # TEMPLATE: rmPos.new(lA_x, lA_y, lA_z,lAO_x, lH_x, lH_y, lH_z, rA_x, rA_y, rA_z,rAO_x, rH_x, rH_y, rH_z)
	rest:       rmPos.new(  80,    0,    0,    0,    0,    0,    0,  -80,    0,    0,    0,    0,    0,    0),
	stop:       rmPos.new( -55,    0,    0,  -70,    0,    0,    0,   55,    0,    0,   70,    0,    0,    0),
	fwd_out:    rmPos.new(   0,    0,  -50,  -30,    0,    0,    0,    0,    0,   50,   30,    0,    0,    0),
	fwd_in:     rmPos.new(   0,    0,  -50, -120,    0,    0,    0,    0,    0,   50,  120,    0,    0,    0),
	left_in:    rmPos.new(   0,    0,    0, -120,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0),
	left_out:   rmPos.new(   0,    0,    0,  -30,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0),
	right_in:   rmPos.new(   0,    0,    0,    0,    0,    0,    0,    0,    0,    0,  120,    0,    0,    0),
	right_out:  rmPos.new(   0,    0,    0,    0,    0,    0,    0,    0,    0,    0,   30,    0,    0,    0)
};

# Return current position values
var get_pos_values = func(ramp_tree)
{
	return rmPos.new(
		getprop(ramp_tree~"left-arm-x"),
		getprop(ramp_tree~"left-arm-y"),
		getprop(ramp_tree~"left-arm-z"),
		getprop(ramp_tree~"left-arm-outer-x"),
		getprop(ramp_tree~"left-hand-x"),
		getprop(ramp_tree~"left-hand-y"),
		getprop(ramp_tree~"left-hand-z"),
		getprop(ramp_tree~"right-arm-x"),
		getprop(ramp_tree~"right-arm-y"),
		getprop(ramp_tree~"right-arm-z"),
		getprop(ramp_tree~"right-arm-outer-x"),
		getprop(ramp_tree~"right-hand-x"),
		getprop(ramp_tree~"right-hand-y"),
		getprop(ramp_tree~"right-hand-z")
	);
};

var check_pos = func(ramp_tree, target)
{
	var position = get_pos_values(ramp_tree);

	if(
		(position.lA_x == target.lA_x) and
		(position.lA_y == target.lA_y) and
		(position.lA_z == target.lA_z) and
		(position.lAO_x == target.lAO_x) and
		(position.lH_x == target.lH_x) and
		(position.lH_y == target.lH_y) and
		(position.lH_z == target.lH_z) and
		(position.rA_x == target.rA_x) and
		(position.rA_y == target.rA_y) and
		(position.rA_z == target.rA_z) and
		(position.rAO_x == target.rAO_x) and
		(position.rH_x == target.rH_x) and
		(position.rH_y == target.rH_y) and
		(position.rH_z == target.rH_z)
	)
	{
		return 1;
	}
	else
	{
		return 0;
	}
};

var full_animate = func(ramp_tree, pos_hash, rate)
{
	animate(ramp_tree~"left-arm-x",pos_hash.lA_x , rate);
	animate(ramp_tree~"left-arm-y",pos_hash.lA_y , rate);
	animate(ramp_tree~"left-arm-z",pos_hash.lA_z , rate);
	animate(ramp_tree~"left-arm-outer-x",pos_hash.lAO_x , rate);
	animate(ramp_tree~"left-hand-x",pos_hash.lH_x , rate);
	animate(ramp_tree~"left-hand-y",pos_hash.lH_y , rate);
	animate(ramp_tree~"left-hand-z",pos_hash.lH_z , rate);
	animate(ramp_tree~"right-arm-x",pos_hash.rA_x , rate);
	animate(ramp_tree~"right-arm-y",pos_hash.rA_y , rate);
	animate(ramp_tree~"right-arm-z",pos_hash.rA_z , rate);
	animate(ramp_tree~"right-arm-outer-x",pos_hash.rAO_x , rate);
	animate(ramp_tree~"right-hand-x",pos_hash.rH_x , rate);
	animate(ramp_tree~"right-hand-y",pos_hash.rH_y , rate);
	animate(ramp_tree~"right-hand-z",pos_hash.rH_z , rate);
};

# Smooth Property Animation
var animate = func(prop, target, rate) { # Rate is in deg/sec
	
	var delta_sec = getprop("/sim/time/delta-sec");
	if(rate == nil) {
		rate = 50;
	}
	if(delta_sec == nil) {
		delta_sec = 0.1;
	}
	
	var value = getprop(prop);
	if(value != nil) {
		if(math.abs(value-target) > rate*delta_sec) {
			if(value < target) {
				setprop(prop, value + rate*delta_sec);
			} else {
				setprop(prop, value - rate*delta_sec);
			}
		} else {
			if(value != target) {
				setprop(prop, target);
			}
		}
	}
	
}

var addModel = func(path, lat, lon, alt, hdg)
{
	# Derived from jetways.nas

	var models = props.globals.getNode("/models");
	var model = nil;
	for(var i=0; 1; i+=1)
	{
		if(models.getChild("model", i, 0) == nil)
		{
			model = models.getChild("model", i, 1);
			break;
		}
	}

	var model_path = model.getPath();
	model.getNode("path", 1).setValue(path);
	model.getNode("latitude-deg", 1).setDoubleValue(lat);
	model.getNode("latitude-deg-prop", 1).setValue(model_path ~ "/latitude-deg");
	model.getNode("longitude-deg", 1).setDoubleValue(lon);
	model.getNode("longitude-deg-prop", 1).setValue(model_path ~ "/longitude-deg");
	model.getNode("elevation-ft", 1).setDoubleValue(alt * M2FT);
	model.getNode("elevation-ft-prop", 1).setValue(model_path ~ "/elevation-ft");
	model.getNode("heading-deg", 1).setDoubleValue(hdg);
	model.getNode("heading-deg-prop", 1).setValue(model_path ~ "/heading-deg");
	model.getNode("pitch-deg", 1).setDoubleValue(0);
	model.getNode("pitch-deg-prop", 1).setValue(model_path ~ "/pitch-deg");
	model.getNode("roll-deg", 1).setDoubleValue(0);
	model.getNode("roll-deg-prop", 1).setValue(model_path ~ "/roll-deg");
	model.getNode("load", 1).remove();
	return model;
};

var load_ramps = func(icao)
{

    print("Loading ramps from airport...", icao);
    var xml_file = ADDON_BASE_PATH ~ "/AI/Airports/" ~ icao ~ "/ramps.xml";

	var rampsTree = "/airports/"~icao~"/ramps";

	readFile = io.read_properties(xml_file, rampsTree);
	if(readFile == nil)
	{
        print("Airport ramp.xml file is null");
		return;
	}
	else
	{
		setprop(rampsTree~"/loaded", 1); # Set Loaded flag so flightgear doesn't load again

		print("Loaded Ramps at " ~ icao);

		var ramps = props.globals.getNode(rampsTree).getChildren();

		foreach(var ramp; ramps)
		{
			# General Runtime XML
			var index = ramp.getIndex();
			var base_model = ADDON_BASE_PATH ~ "/Models/Airport/Ramp/ramp.xml";

			var tmp = props.globals.getNode(rampsTree~"/models/model", 1);
			tmp.getNode("path", 1).setValue(base_model);

            var tree = rampsTree ~ "/ramp[" ~ index ~ "]/";
            
			setprop(tree~"left-arm-x", pos.rest.lA_x);
			setprop(tree~"left-arm-y", pos.rest.lA_y);
			setprop(tree~"left-arm-z", pos.rest.lA_z);
			setprop(tree~"left-arm-outer-x", pos.rest.lAO_x);
			setprop(tree~"left-hand-x", pos.rest.lH_x);
			setprop(tree~"left-hand-y", pos.rest.lH_y);
			setprop(tree~"left-hand-z", pos.rest.lH_z);
			setprop(tree~"right-arm-x", pos.rest.rA_x);
			setprop(tree~"right-arm-y", pos.rest.rA_y);
			setprop(tree~"right-arm-z", pos.rest.rA_z);
			setprop(tree~"right-arm-outer-x", pos.rest.rAO_x);
			setprop(tree~"right-hand-x", pos.rest.rH_x);
			setprop(tree~"right-hand-y", pos.rest.rH_y);
			setprop(tree~"right-hand-z", pos.rest.rH_z);
			setprop(tree~"function", "rest");

			var params = tmp.getNode("overlay", 1).getNode("params", 1);
			params.getNode("left-arm-x", 1).setValue(tree~"left-arm-x");
			params.getNode("left-arm-y", 1).setValue(tree~"left-arm-y");
			params.getNode("left-arm-outer-x", 1).setValue(tree~"left-arm-outer-x");
			params.getNode("left-arm-z", 1).setValue(tree~"left-arm-z");
			params.getNode("left-hand-x", 1).setValue(tree~"left-hand-x");
			params.getNode("left-hand-y", 1).setValue(tree~"left-hand-y");
			params.getNode("left-hand-z", 1).setValue(tree~"left-hand-z");
			params.getNode("right-arm-x", 1).setValue(tree~"right-arm-x");
			params.getNode("right-arm-y", 1).setValue(tree~"right-arm-y");
			params.getNode("right-arm-outer-x", 1).setValue(tree~"right-arm-outer-x");
			params.getNode("right-arm-z", 1).setValue(tree~"right-arm-z");
			params.getNode("right-hand-x", 1).setValue(tree~"right-hand-x");
			params.getNode("right-hand-y", 1).setValue(tree~"right-hand-y");
			params.getNode("right-hand-z", 1).setValue(tree~"right-hand-z");
			params.getNode("toggle-ramp-marshall-script", 1).setValue("globals[\"" ~ ADDON_NAMESPACE ~ "\"].toggle_marshall(" ~ index ~ ");");

			var model_path = getprop("/sim/fg-home") ~ "/state/ramp-" ~ index ~ ".xml";

			io.write_properties(model_path, rampsTree~"/models");

			var ramp_path = rampsTree ~ "/ramp[" ~ index ~ "]/";

			print("Loaded ramp marshaller #", index);

			# Add model to FlightGear
			addModel(model_path, getprop(ramp_path~"latitude-deg"), getprop(ramp_path~"longitude-deg"), getprop(ramp_path~"altitude-m"), getprop(ramp_path~"heading-deg"));
		}
	}
};

var toggle_marshall = func(id)
{
	var activeRamp = getprop("/airports/active-ramp");
	var rampEnable = getprop("/airports/enable-ramp");

	print("Toggling from marshaller #", activeRamp, "to marshall #", id);
	
	if(rampEnable == 0)
	{
		var ramp_dat = "/airports/"~closestAirport()~"/ramps/ramp["~id~"]/";
		ramp_pos.set_latlon(getprop(ramp_dat~"latitude-deg"), getprop(ramp_dat~"longitude-deg"));
		setprop("/airports/active-ramp", id);
		setprop("/airports/enable-ramp", 1);
	}
	else
	{
		if(activeRamp == id)
		{
			setprop("/airports/enable-ramp", 0); # Disable Ramp
			print("Disabled current marshaller #", id);
		}
		else
		{
			var ramp_dat = "/airports/"~closestAirport()~"/ramps/ramp["~id~"]/";
			ramp_pos.set_latlon(getprop(ramp_dat~"latitude-deg"), getprop(ramp_dat~"longitude-deg"));
			setprop("/airports/active-ramp", id);
		}
	}
};

# Main Loop
var main_loop =
{
	init : func
	{
		me.UPDATE_INTERVAL = 0.01;
		me.function = getprop("rest");
		setprop("/airports/active-arpt", closestAirport());
		setprop("/airports/active-ramp", 0);
		setprop("/airports/enable-ramp", 0);
		me.phase = 0;
		me.loopid = 0;
		me.calcFunc = 1;
		me.reset();
        print("Initialized Ramp Marshall Script ");
	},
	stepTo: func(ramp_tree, pos_hash, rate)
	{
		if(!check_pos(ramp_tree, pos_hash))
		{
			full_animate(ramp_tree, pos_hash, rate);
		}
		if(check_pos(ramp_tree, pos_hash))
		{
			return 1;
		}
		else
		{
			return 0;
		}

	},
	update : func
	{
		if(getprop("/addons/by-id/com.github.renanmsv.rampmarshall/addon-devel/enable") == 1)
		{
			# Check if ramps are loaded at the nearest airport

			if(getprop( "/airports/"~closestAirport()~"/ramps/loaded") == nil)
			{
				load_ramps(closestAirport());
				setprop("/airports/active-arpt", closestAirport());
			}

			var activeRamp = getprop("/airports/active-ramp");

			var ramp_tree = "/airports/"~closestAirport()~"/ramps/ramp["~activeRamp~"]/";

			# If a ramp is enabled, run the function to guide the pilot

			if(getprop("/airports/enable-ramp") == 1)
			{

				if(me.function != getprop(ramp_tree~"function"))
				{
					me.function = getprop(ramp_tree~"function");
					me.phase = 0;
				}

				if(me.calcFunc == 1)
				{
					var ac_pos = geo.aircraft_position();
					var heading = getprop("/orientation/heading-deg");

					var ngear = ac_pos;	
					ngear.apply_course_distance(heading, ramp_dist*M2NM);

					var dist_to_ramp = ngear.distance_to(ramp_pos);

					setprop(ramp_tree~"dist-ramp", dist_to_ramp);

					var taxi_course = ngear.course_to(ramp_pos);

					var deviation = getDeviation(heading, taxi_course);

					setprop(ramp_tree~"deviation", deviation);

					if(math.abs(deviation) > 150)
					{
						setprop(ramp_tree~"function", "imm_stop");
					}
					elsif(deviation > 1)
					{
						setprop(ramp_tree~"function", "turn_right");
					}
					elsif(deviation < -1)
					{
						setprop(ramp_tree~"function", "turn_left");
					}
					else
					{
						if(dist_to_ramp > ramp_dist + 2)
						{
							setprop(ramp_tree~"function", "move_fwd");
						}
						elsif(dist_to_ramp > ramp_dist + 0.3)
						{
							setprop(ramp_tree~"function", "slow_stop");
						}
						else
						{
							setprop(ramp_tree~"function", "imm_stop");
						}
					}
				}

				# Ramp Marshall Signals

				if(me.function == "slow_stop")
				{
					if(me.phase == 0)
					{
						if(me.stepTo(ramp_tree, pos.rest, 140))
						{
							me.phase = 1;
						}
					}
					elsif(!check_pos(ramp_tree, pos.stop) and me.phase == 1)
					{
						full_animate(ramp_tree, pos.stop, 60);
					}
				}

				if(me.function == "rest")
				{
					if(!check_pos(ramp_tree, pos.rest))
					{
						full_animate(ramp_tree, pos.rest, 80);
					}
				}

				if(me.function == "imm_stop")
				{
					if(!check_pos(ramp_tree, pos.stop))
					{
						full_animate(ramp_tree, pos.stop, 240);
					}
				}

				if(me.function == "move_fwd")
				{
					if(me.phase == 0)
					{
						if(!check_pos(ramp_tree, pos.fwd_in))
						{
							full_animate(ramp_tree, pos.fwd_in, 100);
						}
						if(check_pos(ramp_tree, pos.fwd_in))
						{
							me.phase = 1;
						}
					}
					elsif(!check_pos(ramp_tree, pos.fwd_out) and me.phase == 1)
					{
						full_animate(ramp_tree, pos.fwd_out, 80);
						if(check_pos(ramp_tree, pos.fwd_out))
						{
							me.phase = 2;
						}
					}
					elsif(!check_pos(ramp_tree, pos.fwd_in) and me.phase == 2)
					{
						full_animate(ramp_tree, pos.fwd_in, 80);
						if(check_pos(ramp_tree, pos.fwd_in))
						{
							me.phase = 1;
						}
					}
				}

				if(me.function == "turn_left")
				{
					if(me.phase == 0)
					{
						if(!check_pos(ramp_tree, pos.left_in))
						{
							full_animate(ramp_tree, pos.left_in, 100);
						}
						if(check_pos(ramp_tree, pos.left_in))
						{
							me.phase = 1;
						}
					}
					elsif(!check_pos(ramp_tree, pos.left_out) and me.phase == 1)
					{
						full_animate(ramp_tree, pos.left_out, 80);
						if(check_pos(ramp_tree, pos.left_out))
						{
							me.phase = 2;
						}
					}
					elsif(!check_pos(ramp_tree, pos.left_in) and me.phase == 2)
					{
						full_animate(ramp_tree, pos.left_in, 80);
						if(check_pos(ramp_tree, pos.left_in))
						{
							me.phase = 1;
						}
					}
				}

				if(me.function == "turn_right")
				{
					if(me.phase == 0)
					{
						if(!check_pos(ramp_tree, pos.right_in))
						{
							full_animate(ramp_tree, pos.right_in, 100);
						}
						if(check_pos(ramp_tree, pos.right_in))
						{
							me.phase = 1;
						}
					}
					elsif(!check_pos(ramp_tree, pos.right_out) and me.phase == 1)
					{
						full_animate(ramp_tree, pos.right_out, 80);
						if(check_pos(ramp_tree, pos.right_out))
						{
							me.phase = 2;
						}
					}
					elsif(!check_pos(ramp_tree, pos.right_in) and me.phase == 2)
					{
						full_animate(ramp_tree, pos.right_in, 80);
						if(check_pos(ramp_tree, pos.right_in))
						{
							me.phase = 1;
						}
					}
				}
			}
			else
			{
				# Return to rest position
				full_animate(ramp_tree, pos.rest, 80);	
			}
		}
	},

	reset : func
	{
		me.loopid += 1;
		me._loop_(me.loopid);
	},

	_loop_ : func(id)
	{
		id == me.loopid or return;
		me.update();
		settimer(func { me._loop_(id); }, me.UPDATE_INTERVAL);
	}
};

# Editor/Converter

var filedlg = 0;

var posData =
{
	lat: 0,
	lon: 0,
	alt: 0,
	hdg: 0,
	new: func(lat, lon, alt, hdg)
	{
		var m = { parents: [posData] };
		m.lat = lat;
		m.lon = lon;
		m.alt = alt;
		m.hdg = hdg;

		return m;
	}
};

var rampPos = [];
var ramp_pos = geo.Coord.new();
var ramp_dist = getprop("/sim/model/ramp/x-m");
if (ramp_dist == nil) {
	ramp_dist = -14;
}

var convert_stg = func()
{
	setprop("/sim/gui/dialogs/file-select/show-files", 1);
	fgcommand("dialog-show", props.Node.new({ "dialog-name": "file-select" }));
	setprop("/sim/gui/dialogs/file-select/path", "");

	filedlg = setlistener("/sim/gui/dialogs/file-select/path", func(n)
	{
		removelistener(filedlg);
		var path = n.getValue();
		if (path == "") return;
		var stg = io.open(path, mode="r");
		var n = 0;
		while(var stg_line = io.readln(stg))
		{
			var line_data = split(" ", stg_line);

			if(substr(line_data[0],0,1) != "#")
			{
				# Comment Line
				if((line_data[0] == "OBJECT_SHARED") and (line_data[1] == "Models/Airport/Ramp/ramp.xml"))
				{
					# Valid Ramp Model
					append(rampPos, posData.new(line_data[3], line_data[2], line_data[4], line_data[5]));
				}
			}
		}

		for(var i=0; i<size(rampPos); i+=1)
		{
			setprop("/airports/export/ramps/ramp["~i~"]/latitude-deg", rampPos[i].lat);
			setprop("/airports/export/ramps/ramp["~i~"]/longitude-deg", rampPos[i].lon);
			setprop("/airports/export/ramps/ramp["~i~"]/altitude-m", rampPos[i].alt);
			setprop("/airports/export/ramps/ramp["~i~"]/heading-deg", geo.normdeg(360 - rampPos[i].hdg));
		}

		var location = "/airports/export/ramps/";
		var filename = getprop("/sim/fg-home") ~ "/Export/ramps-export.xml";

		io.write_properties(filename, location);

		print("Converted to STG");
	});
};

var getDeviation = func(hdg, target) {
	var deviation = target - hdg;
	if(deviation < -180) {
		deviation = 360 - deviation;
	} elsif(deviation > 180) {
		deviation = deviation - 360;
	}
	return deviation;
}

var closestAirport = func() {
	return getprop("/sim/airport/closest-airport-id");
};

var unload = func(addon) {
    # This function is for addon development only. It is called on addon 
    # reload. The addons system will replace setlistener() and maketimer() to
    # track this resources automatically for you.
    #
    # Listeners created with setlistener() will be removed automatically for you.
    # Timers created with maketimer() will have their stop() method called 
    # automatically for you. You should NOT use settimer anymore, see wiki at
    # http://wiki.flightgear.org/Nasal_library#maketimer.28.29
    #
    # Other resources should be freed by adding the corresponding code here,
    # e.g. myCanvas.del();
}

var ADDON_BASE_PATH = 0;
var ADDON_NAMESPACE = 0;

var main = func(addon) {
    printlog("alert", "Ramp marshall addon initialized from path ", addon.basePath);
    ADDON_BASE_PATH = addon.basePath;
	ADDON_NAMESPACE = "__addon[" ~ addon.id ~ "]__";
    _setlistener("sim/signals/fdm-initialized", func()
    {	
        main_loop.init();
    });
}
