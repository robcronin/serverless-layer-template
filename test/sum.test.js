import { sum } from '../commonFunctions/index';

describe('Test sum works', () => {
  it('it sums correctly', () => {
    expect(sum(2, 3)).toBe(5);
  });
});