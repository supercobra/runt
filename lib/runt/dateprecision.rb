#!/usr/bin/env ruby

require 'runt'
require 'date'

module Runt

  # :title:DPrecision
  # == DPrecision
  #
  #
  # Inspired by a <tt>pattern</tt>[http://martinfowler.com/ap2/timePoint.html] by Martin Fowler.
  #
  #
  # Author:: Matthew Lipper
  module DPrecision

    def DPrecision.to_p(date,prec=DEFAULT)

      case prec
        when MINUTE then PDate.minute(*DPrecision.explode(date,prec))
        when DAY_OF_MONTH then PDate.day_of_month(*DPrecision.explode(date,prec))
        when HOUR_OF_DAY then PDate.hour_of_day(*DPrecision.explode(date,prec))
        when MONTH then PDate.month(*DPrecision.explode(date,prec))
        when YEAR then PDate.year(*DPrecision.explode(date,prec))
        when SECOND then PDate.second(*DPrecision.explode(date,prec))
        when MILLISECOND then raise "Not implemented."
        else PDate.default(*DPrecision.explode(date,prec))
      end
    end

    def DPrecision.explode(date,prec)
      result = [date.year,date.month,date.day]
        if(date.respond_to?("hour"))
          result << date.hour << date.min << date.sec
        else
          result << 0 << 0 << 0
        end
      result
    end

    #Simple value class for keeping track of precisioned dates
    class Precision
      include Comparable

      attr_reader :precision
      private_class_method :new

      #Some constants w/arbitrary integer values used internally for comparisions
      YEAR_PREC = 0
      MONTH_PREC = 1
      DAY_OF_MONTH_PREC = 2
      HOUR_OF_DAY_PREC = 3
      MINUTE_PREC = 4
      SECOND_PREC = 5
      MILLISECOND_PREC = 6

      #String values for display
      LABEL = { YEAR_PREC => "YEAR",
        MONTH_PREC => "MONTH",
        DAY_OF_MONTH_PREC => "DAY_OF_MONTH",
        HOUR_OF_DAY_PREC => "HOUR_OF_DAY",
        MINUTE_PREC => "MINUTE",
        SECOND_PREC => "SECOND",
        MILLISECOND_PREC => "MILLISECOND"}

      #Minimun values that precisioned fields get set to
      FIELD_MIN = { YEAR_PREC => 1,
      MONTH_PREC => 1,
      DAY_OF_MONTH_PREC => 1,
      HOUR_OF_DAY_PREC => 0,
      MINUTE_PREC => 0,
      SECOND_PREC => 0,
      MILLISECOND_PREC => 0}

      def Precision.year
        new(YEAR_PREC)
      end

      def Precision.month
        new(MONTH_PREC)
      end

      def Precision.day_of_month
        new(DAY_OF_MONTH_PREC)
      end

      def Precision.hour_of_day
        new(HOUR_OF_DAY_PREC)
      end

      def Precision.minute
        new(MINUTE_PREC)
      end

      def Precision.second
        new(SECOND_PREC)
      end

      def Precision.millisecond
        new(MILLISECOND_PREC)
      end

      def min_value()
        FIELD_MIN[@precision]
      end

      def initialize(prec)
        @precision = prec
      end

      def <=>(other)
        self.precision <=> other.precision
      end

      def ===(other)
        self.precision == other.precision
      end

      def to_s
        "DPrecision::#{LABEL[@precision]}"
      end
  end

  #Pseudo Singletons:
  YEAR = Precision.year
  MONTH = Precision.month
  DAY_OF_MONTH = Precision.day_of_month
  HOUR_OF_DAY = Precision.hour_of_day
  MINUTE = Precision.minute
  SECOND = Precision.second
  MILLISECOND = Precision.millisecond
  DEFAULT=MINUTE

  end

end