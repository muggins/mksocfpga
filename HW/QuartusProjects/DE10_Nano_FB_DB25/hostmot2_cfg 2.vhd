library IEEE;
use IEEE.std_logic_1164.all;  -- defines std_logic types
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;
--
-- Copyright (C) 2007, Peter C. Wallace, Mesa Electronics
-- http://www.mesanet.com
--
-- This program is is licensed under a disjunctive dual license giving you
-- the choice of one of the two following sets of free software/open source
-- licensing terms:
--
--    * GNU General Public License (GPL), version 2.0 or later
--    * 3-clause BSD License
--
--
-- The GNU GPL License:
--
--     This program is free software; you can redistribute it and/or modify
--     it under the terms of the GNU General Public License as published by
--     the Free Software Foundation; either version 2 of the License, or
--     (at your option) any later version.
--
--     This program is distributed in the hope that it will be useful,
--     but WITHOUT ANY WARRANTY; without even the implied warranty of
--     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--     GNU General Public License for more details.
--
--     You should have received a copy of the GNU General Public License
--     along with this program; if not, write to the Free Software
--     Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
--
--
-- The 3-clause BSD License:
--
--     Redistribution and use in source and binary forms, with or without
--     modification, are permitted provided that the following conditions
--     are met:
--
--         * Redistributions of source code must retain the above copyright
--           notice, this list of conditions and the following disclaimer.
--
--         * Redistributions in binary form must reproduce the above
--           copyright notice, this list of conditions and the following
--           disclaimer in the documentation and/or other materials
--           provided with the distribution.
--
--         * Neither the name of Mesa Electronics nor the names of its
--           contributors may be used to endorse or promote products
--           derived from this software without specific prior written
--           permission.
--
--
-- Disclaimer:
--
--     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
--     "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
--     LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
--     FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
--     COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
--     INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
--     BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
--     LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
--     CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
--     LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
--     ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--     POSSIBILITY OF SUCH DAMAGE.
--

library work;
use work.IDROMConst.all;
use work.DE10_Nano_FB_DB25_card.all;
-- Uncomment one of the following
use work.PIN_7I76_7I76_7I76_7I76.all;
--use work.PIN_7I76_7I85S_GPIO_GPIO.all;
--use work.PIN_%CONFIG%.all;

entity HostMot2_cfg is
   	generic
	(
	ThePinDesc: PinDescType;
	TheModuleID: ModuleIDType;
	IDROMType: integer;
	SepClocks: boolean;
	OneWS: boolean;
	UseStepGenPrescaler : boolean;
	UseIRQLogic: boolean;
	PWMRefWidth: integer;
	UseWatchDog: boolean;
	OffsetToModules: integer;
	OffsetToPinDesc: integer;
	ClockHigh: integer;
	ClockMed: integer;
	ClockLow: integer;
	BoardNameLow : std_Logic_Vector(31 downto 0);
	BoardNameHigh : std_Logic_Vector(31 downto 0);
	FPGASize: integer;
	FPGAPins: integer;
	IOPorts: integer;
	IOWidth: integer;
	PortWidth: integer;
	LIOWidth: integer;
	LEDCount: integer;
	BusWidth: integer;
	AddrWidth: integer;
	InstStride0: integer;
	InstStride1: integer;
	RegStride0: integer;
	RegStride1: integer
		);
   port (
     -- Generic 32  bit bus interface signals --
    ibus        : in std_logic_vector(buswidth -1 downto 0);
    obus        : out std_logic_vector(buswidth -1 downto 0);
    addr        : in std_logic_vector(addrwidth -1 downto 2);
    readstb     : in std_logic;
    writestb    : in std_logic;
    clklow      : in std_logic;
    clkmed      : in std_logic;
    clkhigh     : in std_logic;
    irq         : out std_logic;
    dreq        : out std_logic;
    demandmode  : out std_logic;
    iobits      : inout std_logic_vector (iowidth -1 downto 0);
    liobits     : inout std_logic_vector (liowidth -1 downto 0);
    rates       : out std_logic_vector (4 downto 0);
    leds        : out std_logic_vector(ledcount-1 downto 0) );
end HostMot2_cfg;

architecture arch of HostMot2_cfg is

	signal ibus_sig : std_logic_vector(BusWidth -1 downto 0);
	signal obus_sig : std_logic_vector(BusWidth -1 downto 0);
	signal addr_sig    : std_logic_vector(AddrWidth -1 downto 2);
	signal readstb_sig : std_logic;
	signal writestb_sig : std_logic;
	signal intirq_sig  : std_logic;
	signal iobitsout_sig : std_logic_vector(IOWidth -1 downto 0);
	signal iobitsin_sig : std_logic_vector(IOWidth -1 downto 0);
	signal leds_sig : std_logic_vector(LEDCount -1 downto 0);

begin

	process (clkhigh)
	begin
		if rising_edge(clkhigh) then
			ibus_sig <= ibus;
			obus <= obus_sig;
			addr_sig <= addr;
			readstb_sig <= readstb;
			writestb_sig <= writestb;
			intirq <= intirq_sig;
			iobitsout <= iobitsout_sig;
			iobitsin_sig <= iobitsin;
			leds <= leds_sig;
		end if;
	end process;

    aHostMot2_cfg: entity work.HostMot2
    generic map (
        ThePinDesc              => PinDesc,
        TheModuleID             => ModuleID,
        IDROMType               => 3,
        SepClocks               => SepClocks,
        OneWS                   => OneWS,
        UseStepGenPrescaler     => true,
        UseIRQLogic             => true,
        PWMRefWidth             => 13,
        UseWatchDog             => true,
        OffsetToModules         => 64,
        OffsetToPinDesc         => 448,
        ClockHigh               => ClockHigh,
        ClockMed                => ClockMed,
        ClockLow                => ClockLow,
        BoardNameLow            => BoardNameLow,
        BoardNameHigh           => BoardNameHigh,
        FPGASize                => FPGASize,
        FPGAPins                => FPGAPins,
        IOPorts                 => IOPorts,
        IOWidth                 => IOWidth,
        LIOWidth                => LIOWidth,
        PortWidth               => PortWidth,
        BusWidth                => 32,
        AddrWidth               => 16,
        InstStride0             => 4,
        InstStride1             => 64,
        RegStride0              => 256,
        RegStride1              => 256,
        LEDCount                => LEDCount )
    port map (
        ibus                    => ibus,
        obus                    => obus,
        addr                    => addr,
        readstb                 => readstb,
        writestb                => writestb,
        clklow                  => clklow,
        clkmed                  => clkmed,
        clkhigh                 => clkhigh,
        int                     => irq,
        dreq                    => dreq,
        demandmode              => demandmode,
        iobits                  => iobits,
        liobits                 => liobits,
        rates                   => rates,
        leds                    => leds );
end arch;
